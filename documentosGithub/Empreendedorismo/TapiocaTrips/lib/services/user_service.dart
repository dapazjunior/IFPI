import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Serviço para gerenciamento do perfil do usuário
/// Utiliza SharedPreferences para persistência local simples e eficiente
class UserService {
  static const String _userProfileKey = 'user_profile';
  static UserProfile? _currentUser;
  static SharedPreferences? _prefs;

  /// Inicializa o serviço
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserProfile();
  }

  /// Carrega o perfil do usuário do armazenamento local
  static Future<void> _loadUserProfile() async {
    if (_prefs == null) return;

    final userJson = _prefs!.getString(_userProfileKey);
    
    if (userJson != null) {
      try {
        final userMap = _parseJsonString(userJson);
        _currentUser = UserProfile.fromJson(userMap);
      } catch (e) {
        // Se houver erro ao carregar, cria um usuário padrão
        await _createDefaultUser();
      }
    } else {
      // Se não existir perfil, cria um usuário padrão
      await _createDefaultUser();
    }
  }

  /// Cria um usuário padrão
  static Future<void> _createDefaultUser() async {
    _currentUser = UserProfile(
      name: 'Viajante Tapioca',
      email: 'viajante@tapiocatrips.com',
      avatarUrl: null,
      favoriteRouteIds: [],
      recentlyViewedRoutes: [],
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    await _saveUserProfileToStorage();
  }

  /// Parse seguro de string JSON
  static Map<String, dynamic> _parseJsonString(String jsonString) {
    try {
      // Implementação básica de parse - em app real usar jsonDecode
      // Esta é uma implementação simplificada para o exemplo
      final Map<String, dynamic> result = {};
      final cleanedJson = jsonString.replaceAll('{', '').replaceAll('}', '');
      final pairs = cleanedJson.split(',');
      
      for (final pair in pairs) {
        final keyValue = pair.split(':');
        if (keyValue.length == 2) {
          final key = keyValue[0].trim().replaceAll('"', '');
          var value = keyValue[1].trim().replaceAll('"', '');
          
          // Conversão básica de tipos
          if (key == 'favoriteRouteIds' || key == 'recentlyViewedRoutes') {
            result[key] = value
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(';')
                .where((item) => item.isNotEmpty)
                .toList();
          } else {
            result[key] = value;
          }
        }
      }
      
      return result;
    } catch (e) {
      throw Exception('Erro ao fazer parse do perfil do usuário: $e');
    }
  }

  /// Salva o perfil do usuário no armazenamento local
  static Future<void> _saveUserProfileToStorage() async {
    if (_prefs == null || _currentUser == null) return;

    try {
      final userJson = _currentUser!.toJson().toString();
      await _prefs!.setString(_userProfileKey, userJson);
    } catch (e) {
      throw Exception('Erro ao salvar perfil do usuário: $e');
    }
  }

  /// Obtém o perfil atual do usuário
  static UserProfile? get currentUser => _currentUser;

  /// Salva um perfil de usuário
  static Future<void> saveUserProfile(UserProfile user) async {
    _currentUser = user.copyWith(lastLogin: DateTime.now());
    await _saveUserProfileToStorage();
  }

  /// Carrega o perfil do usuário
  static Future<UserProfile?> loadUserProfile() async {
    if (_currentUser == null) {
      await initialize();
    }
    return _currentUser;
  }

  /// Alterna o estado de favorito de uma rota
  static Future<void> toggleFavorite(String routeId) async {
    if (_currentUser == null) await initialize();
    if (_currentUser == null) return;

    if (_currentUser!.isFavorite(routeId)) {
      _currentUser = _currentUser!.removeFavorite(routeId);
    } else {
      _currentUser = _currentUser!.addFavorite(routeId);
    }

    await _saveUserProfileToStorage();
  }

  /// Verifica se uma rota é favorita
  static Future<bool> isFavorite(String routeId) async {
    if (_currentUser == null) await initialize();
    return _currentUser?.isFavorite(routeId) ?? false;
  }

  /// Obtém a lista de IDs de rotas favoritas
  static Future<List<String>> getFavorites() async {
    if (_currentUser == null) await initialize();
    return _currentUser?.favoriteRouteIds ?? [];
  }

  /// Adiciona uma rota ao histórico de visualizações
  static Future<void> addRecentlyViewed(String routeId) async {
    if (_currentUser == null) await initialize();
    if (_currentUser == null) return;

    _currentUser = _currentUser!.addToRecentlyViewed(routeId);
    await _saveUserProfileToStorage();
  }

  /// Obtém o histórico de rotas visualizadas
  static Future<List<String>> getRecentlyViewed() async {
    if (_currentUser == null) await initialize();
    return _currentUser?.recentlyViewedRoutes ?? [];
  }

  /// Limpa o histórico de visualizações
  static Future<void> clearHistory() async {
    if (_currentUser == null) await initialize();
    if (_currentUser == null) return;

    _currentUser = _currentUser!.clearHistory();
    await _saveUserProfileToStorage();
  }

  /// Atualiza informações básicas do usuário
  static Future<void> updateUserInfo({String? name, String? email, String? avatarUrl}) async {
    if (_currentUser == null) await initialize();
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
    
    await _saveUserProfileToStorage();
  }

  /// Obtém estatísticas do usuário
  static Map<String, dynamic> getUserStats() {
    if (_currentUser == null) {
      return {
        'favoritesCount': 0,
        'recentlyViewedCount': 0,
        'memberSince': 'Hoje',
      };
    }

    return {
      'favoritesCount': _currentUser!.favoriteRouteIds.length,
      'recentlyViewedCount': _currentUser!.recentlyViewedRoutes.length,
      'memberSince': _currentUser!.createdAt != null 
          ? '${_currentUser!.createdAt!.day}/${_currentUser!.createdAt!.month}/${_currentUser!.createdAt!.year}'
          : 'Hoje',
    };
  }
}