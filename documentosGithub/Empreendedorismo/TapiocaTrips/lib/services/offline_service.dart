import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../models/route_model.dart';

/// Serviço responsável pelo gerenciamento de rotas offline
/// Baixa e armazena dados de rotas, áudios e informações para uso sem internet
class OfflineService {
  static const String _offlineRoutesKey = 'offline_routes';
  static const String _downloadedAudioKey = 'downloaded_audio_';
  
  final Dio _dio = Dio();
  late Directory _appDocumentsDirectory;

  /// Inicializa o serviço e cria diretórios necessários
  Future<void> initialize() async {
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
    await _createOfflineDirectories();
  }

  /// Cria a estrutura de diretórios para armazenamento offline
  Future<void> _createOfflineDirectories() async {
    final routesDir = Directory('${_appDocumentsDirectory.path}/offline_routes');
    final audioDir = Directory('${_appDocumentsDirectory.path}/offline_audio');
    
    if (!await routesDir.exists()) {
      await routesDir.create(recursive: true);
    }
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
  }

  /// Baixa uma rota completa para uso offline
  /// Inclui metadados da rota e todos os arquivos de áudio dos POIs
  Future<bool> downloadRoute(TourismRoute route) async {
    try {
      // Verifica se a rota já está baixada
      if (await isRouteAvailableOffline(route.id)) {
        throw Exception('Esta rota já está disponível offline');
      }

      // Cria diretório específico para a rota
      final routeDir = Directory('${_appDocumentsDirectory.path}/offline_routes/${route.id}');
      if (!await routeDir.exists()) {
        await routeDir.create(recursive: true);
      }

      // Salva os metadados da rota
      await _saveRouteMetadata(route, routeDir.path);

      // Baixa os áudios dos pontos de interesse
      if (route.pointsOfInterest != null) {
        await _downloadAudioFiles(route.pointsOfInterest!, route.id);
      }

      // Marca a rota como disponível offline
      await _markRouteAsDownloaded(route.id);

      if (kDebugMode) {
        print('✅ Rota "${route.title}" baixada com sucesso para uso offline');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao baixar rota offline: $e');
      }
      // Limpa dados parciais em caso de erro
      await _cleanupPartialDownload(route.id);
      rethrow;
    }
  }

  /// Salva os metadados da rota em arquivo JSON
  Future<void> _saveRouteMetadata(TourismRoute route, String routePath) async {
    final routeFile = File('$routePath/route_data.json');
    final routeJson = route.toJson();
    await routeFile.writeAsString(jsonEncode(routeJson));
  }

  /// Baixa todos os arquivos de áudio dos pontos de interesse
  Future<void> _downloadAudioFiles(List<PointOfInterest> pois, String routeId) async {
    int successCount = 0;
    int totalCount = pois.where((poi) => poi.audioStoryUrl != null && poi.audioStoryUrl!.isNotEmpty).length;

    for (final poi in pois) {
      if (poi.audioStoryUrl != null && poi.audioStoryUrl!.isNotEmpty) {
        try {
          await _downloadAudioFile(poi.audioStoryUrl!, poi.id, routeId);
          successCount++;
          
          // Atualiza progresso (poderia ser usado com um StreamController para UI)
          if (kDebugMode) {
            print('📥 Áudio ${poi.name}: $successCount/$totalCount');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Falha ao baixar áudio ${poi.name}: $e');
          }
          // Continua com outros áudios mesmo se um falhar
        }
      }
    }

    if (successCount == 0 && totalCount > 0) {
      throw Exception('Nenhum áudio pôde ser baixado. Verifique sua conexão.');
    }
  }

  /// Baixa um arquivo de áudio individual
  Future<void> _downloadAudioFile(String audioUrl, String poiId, String routeId) async {
    try {
      final audioDir = Directory('${_appDocumentsDirectory.path}/offline_audio/$routeId');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final audioPath = '${audioDir.path}/$poiId.mp3';
      
      await _dio.download(
        audioUrl,
        audioPath,
        onReceiveProgress: (received, total) {
          if (kDebugMode && total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            print('🎵 Baixando áudio $poiId: $progress%');
          }
        },
      );

      // Salva referência do áudio baixado
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_downloadedAudioKey}$routeId$poiId', audioPath);
      
    } catch (e) {
      throw Exception('Falha no download do áudio: $e');
    }
  }

  /// Marca uma rota como baixada no SharedPreferences
  Future<void> _markRouteAsDownloaded(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedRoutes = prefs.getStringList(_offlineRoutesKey) ?? [];
    
    if (!downloadedRoutes.contains(routeId)) {
      downloadedRoutes.add(routeId);
      await prefs.setStringList(_offlineRoutesKey, downloadedRoutes);
    }
  }

  /// Remove dados parciais em caso de falha no download
  Future<void> _cleanupPartialDownload(String routeId) async {
    try {
      final routeDir = Directory('${_appDocumentsDirectory.path}/offline_routes/$routeId');
      final audioDir = Directory('${_appDocumentsDirectory.path}/offline_audio/$routeId');
      
      if (await routeDir.exists()) {
        await routeDir.delete(recursive: true);
      }
      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
      }
      
      // Remove do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final downloadedRoutes = prefs.getStringList(_offlineRoutesKey) ?? [];
      downloadedRoutes.remove(routeId);
      await prefs.setStringList(_offlineRoutesKey, downloadedRoutes);
      
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Erro durante limpeza de dados parciais: $e');
      }
    }
  }

  /// Verifica se uma rota está disponível offline
  Future<bool> isRouteAvailableOffline(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedRoutes = prefs.getStringList(_offlineRoutesKey) ?? [];
    return downloadedRoutes.contains(routeId);
  }

  /// Carrega uma rota do armazenamento offline
  Future<TourismRoute?> loadOfflineRoute(String routeId) async {
    try {
      if (!await isRouteAvailableOffline(routeId)) {
        return null;
      }

      final routeFile = File('${_appDocumentsDirectory.path}/offline_routes/$routeId/route_data.json');
      
      if (!await routeFile.exists()) {
        await deleteOfflineRoute(routeId); // Limpa estado inconsistente
        return null;
      }

      final routeData = await routeFile.readAsString();
      final routeJson = jsonDecode(routeData) as Map<String, dynamic>;
      
      return TourismRoute.fromJson(routeJson);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao carregar rota offline: $e');
      }
      return null;
    }
  }

  /// Obtém o caminho local de um arquivo de áudio offline
  Future<String?> getOfflineAudioPath(String routeId, String poiId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final audioPath = prefs.getString('${_downloadedAudioKey}$routeId$poiId');
      
      if (audioPath != null) {
        final audioFile = File(audioPath);
        if (await audioFile.exists()) {
          return audioPath;
        } else {
          // Remove referência se arquivo não existe mais
          await prefs.remove('${_downloadedAudioKey}$routeId$poiId');
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao obter caminho do áudio offline: $e');
      }
      return null;
    }
  }

  /// Exclui todos os dados offline de uma rota
  Future<bool> deleteOfflineRoute(String routeId) async {
    try {
      // Remove diretórios da rota
      final routeDir = Directory('${_appDocumentsDirectory.path}/offline_routes/$routeId');
      final audioDir = Directory('${_appDocumentsDirectory.path}/offline_audio/$routeId');
      
      if (await routeDir.exists()) {
        await routeDir.delete(recursive: true);
      }
      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
      }
      
      // Remove do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final downloadedRoutes = prefs.getStringList(_offlineRoutesKey) ?? [];
      downloadedRoutes.remove(routeId);
      await prefs.setStringList(_offlineRoutesKey, downloadedRoutes);
      
      // Remove referências de áudio
      final keysToRemove = <String>[];
      final allKeys = prefs.getKeys();
      
      for (final key in allKeys) {
        if (key.startsWith('${_downloadedAudioKey}$routeId')) {
          keysToRemove.add(key);
        }
      }
      
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }

      if (kDebugMode) {
        print('🗑️ Rota $routeId removida do armazenamento offline');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao excluir rota offline: $e');
      }
      return false;
    }
  }

  /// Obtém o tamanho total do armazenamento offline em MB
  Future<double> getOfflineStorageSize() async {
    try {
      final routesDir = Directory('${_appDocumentsDirectory.path}/offline_routes');
      final audioDir = Directory('${_appDocumentsDirectory.path}/offline_audio');
      
      if (!await routesDir.exists() && !await audioDir.exists()) {
        return 0.0;
      }

      int totalSize = 0;
      
      if (await routesDir.exists()) {
        final routes = await routesDir.list(recursive: true).toList();
        for (final entity in routes) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      
      if (await audioDir.exists()) {
        final audios = await audioDir.list(recursive: true).toList();
        for (final entity in audios) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      
      return totalSize / (1024 * 1024); // Converter para MB
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao calcular tamanho do armazenamento: $e');
      }
      return 0.0;
    }
  }

  /// Obtém lista de IDs de rotas disponíveis offline
  Future<List<String>> getDownloadedRouteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_offlineRoutesKey) ?? [];
  }
}