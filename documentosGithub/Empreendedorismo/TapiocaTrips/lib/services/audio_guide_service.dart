import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poi_model.dart';
import './gamification_service.dart';

/// Serviço responsável pelo sistema de áudio-guia inteligente
/// Gerencia download, reprodução e detecção de proximidade de POIs
class AudioGuideService {
  static const String _downloadedAudiosKey = 'downloaded_audio_paths';
  static const double _proximityThreshold = 50.0; // 50 metros
  static const int _locationUpdateInterval = 10; // segundos
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();
  
  Position? _currentPosition;
  Stream<Position>? _positionStream;
  List<PointOfInterest> _currentRoutePOIs = [];
  PointOfInterest? _currentPlayingPOI;
  AudioPlaybackStatus _playbackStatus = AudioPlaybackStatus.stopped;
  bool _autoPlayEnabled = true;
  bool _isServiceRunning = false;
  
  // Listeners
  final ValueNotifier<AudioPlaybackStatus> _playbackNotifier = 
      ValueNotifier(AudioPlaybackStatus.stopped);
  final ValueNotifier<PointOfInterest?> _currentPOINotifier = ValueNotifier(null);
  final ValueNotifier<ProximityEvent?> _proximityNotifier = ValueNotifier(null);
  
  static final AudioGuideService _instance = AudioGuideService._internal();
  factory AudioGuideService() => _instance;
  AudioGuideService._internal();

  /// Inicializa o serviço de áudio-guia
  Future<void> initialize() async {
    await _requestLocationPermission();
    await _loadPreferences();
    _setupAudioPlayerListeners();
  }

  /// Configura os listeners do player de áudio
  void _setupAudioPlayerListeners() {
    _audioPlayer.playerStateStream.listen((playerState) {
      switch (playerState.processingState) {
        case ProcessingState.idle:
          _playbackNotifier.value = AudioPlaybackStatus.stopped;
          break;
        case ProcessingState.loading:
          _playbackNotifier.value = AudioPlaybackStatus.loading;
          break;
        case ProcessingState.ready:
          if (playerState.playing) {
            _playbackNotifier.value = AudioPlaybackStatus.playing;
          } else {
            _playbackNotifier.value = AudioPlaybackStatus.paused;
          }
          break;
        case ProcessingState.buffering:
          _playbackNotifier.value = AudioPlaybackStatus.loading;
          break;
        case ProcessingState.completed:
          _onAudioCompleted();
          break;
      }
    });

    _audioPlayer.positionStream.listen((position) {
      // Pode ser usado para atualizar UI de progresso
    });
  }

  /// Solicita permissão de localização
  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }

  /// Carrega preferências do usuário
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _autoPlayEnabled = prefs.getBool('auto_play_enabled') ?? true;
  }

  /// Salva preferências do usuário
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_play_enabled', _autoPlayEnabled);
  }

  /// Inicia o monitoramento de localização para uma rota
  Future<void> startRouteMonitoring(List<PointOfInterest> pois) async {
    _currentRoutePOIs = pois;
    _isServiceRunning = true;
    
    // Inicia stream de localização
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // metros
        timeLimit: Duration(seconds: _locationUpdateInterval),
      ),
    );
    
    _positionStream?.listen(_onPositionUpdate);
  }

  /// Para o monitoramento de localização
  void stopRouteMonitoring() {
    _isServiceRunning = false;
    _currentRoutePOIs.clear();
    _positionStream = null;
    _proximityNotifier.value = null;
  }

  /// Processa atualização de posição
  void _onPositionUpdate(Position position) {
    _currentPosition = position;
    
    // Verifica proximidade com cada POI
    for (final poi in _currentRoutePOIs) {
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        poi.latitude,
        poi.longitude,
      );
      
      if (distance <= _proximityThreshold) {
        final event = ProximityEvent(
          poi: poi,
          distance: distance,
          timestamp: DateTime.now(),
        );
        
        _proximityNotifier.value = event;
        
        // Sugere reprodução automática se habilitado
        if (_autoPlayEnabled && 
            _playbackStatus != AudioPlaybackStatus.playing &&
            poi.hasAudio) {
          _suggestAudioPlayback(poi);
        }
        
        break; // Processa apenas o POI mais próximo
      }
    }
  }

  /// Calcula distância entre duas coordenadas (em metros)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Sugere reprodução de áudio para um POI
  void _suggestAudioPlayback(PointOfInterest poi) {
    if (kDebugMode) {
      print('🎧 Sugerindo áudio para: ${poi.name}');
    }
    
    // Emite evento para a UI
    _currentPOINotifier.value = poi;
    
    // TODO: Mostrar notificação/dialog para o usuário confirmar
  }

  /// Baixa áudio de um POI para armazenamento local
  Future<bool> downloadPOIAudio(PointOfInterest poi) async {
    if (poi.audioStoryUrl == null) return false;
    
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${appDir.path}/narratives_audio');
      
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      final audioPath = '${audioDir.path}/${poi.id}.mp3';
      
      await _dio.download(
        poi.audioStoryUrl!,
        audioPath,
        onReceiveProgress: (received, total) {
          if (kDebugMode && total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            print('📥 Baixando áudio ${poi.name}: $progress%');
          }
        },
      );
      
      // Salva referência do arquivo baixado
      await _saveAudioPath(poi.id, audioPath);
      
      // Atualiza o POI com o caminho local
      final updatedPOI = poi.markAsDownloaded(audioPath);
      _updateCurrentRoutePOI(updatedPOI);
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao baixar áudio ${poi.name}: $e');
      }
      return false;
    }
  }

  /// Salva caminho do áudio baixado
  Future<void> _saveAudioPath(String poiId, String audioPath) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedAudios = prefs.getStringList(_downloadedAudiosKey) ?? [];
    
    // Remove entrada existente se houver
    downloadedAudios.removeWhere((entry) => entry.startsWith('$poiId:'));
    
    // Adiciona nova entrada
    downloadedAudios.add('$poiId:$audioPath');
    await prefs.setStringList(_downloadedAudiosKey, downloadedAudios);
  }

  /// Obtém caminho local do áudio de um POI
  Future<String?> getLocalAudioPath(String poiId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedAudios = prefs.getStringList(_downloadedAudiosKey) ?? [];
    
    for (final entry in downloadedAudios) {
      final parts = entry.split(':');
      if (parts.length >= 2 && parts[0] == poiId) {
        return parts[1];
      }
    }
    
    return null;
  }

  /// Reproduz áudio de um POI
  Future<void> playPOIAudio(PointOfInterest poi) async {
    try {
      _currentPlayingPOI = poi;
      _currentPOINotifier.value = poi;
      
      String audioSource;
      
      // Prefere áudio local se disponível
      if (poi.isAudioAvailableOffline && poi.localAudioPath != null) {
        audioSource = poi.localAudioPath!;
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(audioSource)));
      } else if (poi.audioStoryUrl != null) {
        audioSource = poi.audioStoryUrl!;
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioSource)));
      } else {
        throw Exception('Nenhuma fonte de áudio disponível');
      }
      
      await _audioPlayer.play();
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao reproduzir áudio ${poi.name}: $e');
      }
      _playbackNotifier.value = AudioPlaybackStatus.error;
      rethrow;
    }
  }

  /// Pausa reprodução atual
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  /// Continua reprodução
  Future<void> resumeAudio() async {
    await _audioPlayer.play();
  }

  /// Para reprodução
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _currentPlayingPOI = null;
    _currentPOINotifier.value = null;
  }

  /// Chamado quando áudio é completado
  void _onAudioCompleted() async {
    if (_currentPlayingPOI != null) {
      // Marca como reproduzido
      final updatedPOI = _currentPlayingPOI!.markAsPlayed();
      _updateCurrentRoutePOI(updatedPOI);
      
      // Concede XP por ouvir narrativa
      await GamificationService.addXP(30, 'Ouviu narrativa: ${_currentPlayingPOI!.name}');
      
      _currentPlayingPOI = null;
      _currentPOINotifier.value = null;
    }
    
    _playbackNotifier.value = AudioPlaybackStatus.stopped;
  }

  /// Atualiza POI na lista atual
  void _updateCurrentRoutePOI(PointOfInterest updatedPOI) {
    final index = _currentRoutePOIs.indexWhere((poi) => poi.id == updatedPOI.id);
    if (index != -1) {
      _currentRoutePOIs[index] = updatedPOI;
    }
  }

  /// Alterna reprodução automática
  Future<void> toggleAutoPlay() async {
    _autoPlayEnabled = !_autoPlayEnabled;
    await _savePreferences();
  }

  // Getters públicos
  ValueNotifier<AudioPlaybackStatus> get playbackNotifier => _playbackNotifier;
  ValueNotifier<PointOfInterest?> get currentPOINotifier => _currentPOINotifier;
  ValueNotifier<ProximityEvent?> get proximityNotifier => _proximityNotifier;
  bool get autoPlayEnabled => _autoPlayEnabled;
  bool get isServiceRunning => _isServiceRunning;
  PointOfInterest? get currentPlayingPOI => _currentPlayingPOI;
  AudioPlaybackStatus get playbackStatus => _playbackStatus;
  List<PointOfInterest> get currentRoutePOIs => _currentRoutePOIs;

  /// Limpa todos os áudios baixados
  Future<void> clearDownloadedAudios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedAudios = prefs.getStringList(_downloadedAudiosKey) ?? [];
      
      // Deleta arquivos físicos
      for (final entry in downloadedAudios) {
        final parts = entry.split(':');
        if (parts.length >= 2) {
          final file = File(parts[1]);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
      
      // Limpa preferências
      await prefs.remove(_downloadedAudiosKey);
      
      // Atualiza POIs locais
      for (int i = 0; i < _currentRoutePOIs.length; i++) {
        if (_currentRoutePOIs[i].isAudioDownloaded) {
          _currentRoutePOIs[i] = _currentRoutePOIs[i].copyWith(
            isAudioDownloaded: false,
            localAudioPath: null,
          );
        }
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao limpar áudios: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    stopRouteMonitoring();
    _audioPlayer.dispose();
    _playbackNotifier.dispose();
    _currentPOINotifier.dispose();
    _proximityNotifier.dispose();
  }
}