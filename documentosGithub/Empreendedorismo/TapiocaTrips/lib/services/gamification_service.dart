import 'package:shared_preferences/shared_preferences.dart';
import '../models/badge_model.dart';

/// Serviço responsável por gerenciar todo o sistema de gamificação
/// Inclui XP, níveis, conquistas e estatísticas do usuário
class GamificationService {
  static const String _userStatsKey = 'user_stats';
  static const String _badgesKey = 'user_badges';
  static const String _activitiesKey = 'recent_activities';
  
  static UserStats? _currentStats;
  static List<Badge> _allBadges = [];
  static List<String> _recentActivities = [];

  /// Inicializa o serviço e carrega dados do usuário
  static Future<void> initialize() async {
    await _loadUserStats();
    await _initializeBadges();
    await _loadRecentActivities();
  }

  /// Carrega as estatísticas do usuário do armazenamento local
  static Future<void> _loadUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_userStatsKey);
    
    if (statsJson != null) {
      try {
        final statsMap = _parseJsonString(statsJson);
        _currentStats = UserStats.fromJson(statsMap);
      } catch (e) {
        // Se houver erro, cria estatísticas padrão
        await _createDefaultStats();
      }
    } else {
      await _createDefaultStats();
    }
  }

  /// Cria estatísticas padrão para novo usuário
  static Future<void> _createDefaultStats() async {
    _currentStats = const UserStats(
      totalXP: 0,
      level: 1,
      routesCompleted: 0,
      reviewsWritten: 0,
      sharesDone: 0,
      badgesUnlocked: 0,
      lastActivity: DateTime.now(),
    );
    await _saveUserStats();
  }

  /// Inicializa a lista de badges disponíveis
  static Future<void> _initializeBadges() async {
    _allBadges = [
      // Badges de Exploração
      Badge(
        id: 'explorer_green',
        title: '🌿 Explorador Verde',
        description: 'Complete 3 rotas ecológicas',
        icon: '🌿',
        targetValue: 3,
        type: BadgeType.exploration,
      ),
      Badge(
        id: 'sustainable_adventurer',
        title: '🧭 Aventureiro Sustentável',
        description: 'Conclua 5 rotas completas',
        icon: '🧭',
        targetValue: 5,
        type: BadgeType.exploration,
      ),
      Badge(
        id: 'tapioca_ambassador',
        title: '🥇 Embaixador Tapioca',
        description: 'Complete 10 rotas e compartilhe 10 rotas',
        icon: '🥇',
        targetValue: 10,
        type: BadgeType.completion,
      ),

      // Badges Sociais
      Badge(
        id: 'community_guide',
        title: '✍️ Guia da Comunidade',
        description: 'Escreva 3 avaliações para ajudar outros viajantes',
        icon: '✍️',
        targetValue: 3,
        type: BadgeType.social,
      ),
      Badge(
        id: 'tapioca_influencer',
        title: '📢 Influencer Tapioca',
        description: 'Compartilhe 5 rotas com amigos',
        icon: '📢',
        targetValue: 5,
        type: BadgeType.social,
      ),

      // Badges Especiais
      Badge(
        id: 'first_route',
        title: '🚀 Primeira Jornada',
        description: 'Complete sua primeira rota no Tapioca Trips',
        icon: '🚀',
        targetValue: 1,
        type: BadgeType.special,
      ),
      Badge(
        id: 'review_expert',
        title: '⭐ Crítico Experiente',
        description: 'Escreva 10 avaliações detalhadas',
        icon: '⭐',
        targetValue: 10,
        type: BadgeType.social,
      ),
      Badge(
        id: 'exploration_master',
        title: '🏔️ Mestre da Exploração',
        description: 'Complete 15 rotas diferentes',
        icon: '🏔️',
        targetValue: 15,
        type: BadgeType.exploration,
      ),
    ];

    // Carrega o progresso salvo das badges
    await _loadBadgesProgress();
  }

  /// Carrega o progresso das badges do armazenamento
  static Future<void> _loadBadgesProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final badgesJson = prefs.getString(_badgesKey);
    
    if (badgesJson != null) {
      try {
        final badgesList = _parseJsonList(badgesJson);
        for (final badgeData in badgesList) {
          final savedBadge = Badge.fromJson(badgeData);
          final index = _allBadges.indexWhere((b) => b.id == savedBadge.id);
          if (index != -1) {
            _allBadges[index] = savedBadge;
          }
        }
      } catch (e) {
        // Mantém as badges padrão em caso de erro
      }
    }
  }

  /// Carrega atividades recentes
  static Future<void> _loadRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    _recentActivities = prefs.getStringList(_activitiesKey) ?? [];
  }

  /// Salva as estatísticas do usuário
  static Future<void> _saveUserStats() async {
    if (_currentStats == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatsKey, _currentStats!.toJson().toString());
  }

  /// Salva o progresso das badges
  static Future<void> _saveBadgesProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final badgesJson = _allBadges.map((badge) => badge.toJson()).toList().toString();
    await prefs.setString(_badgesKey, badgesJson);
  }

  /// Salva atividades recentes
  static Future<void> _saveRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    // Mantém apenas as últimas 20 atividades
    if (_recentActivities.length > 20) {
      _recentActivities = _recentActivities.sublist(0, 20);
    }
    await prefs.setStringList(_activitiesKey, _recentActivities);
  }

  /// Adiciona uma atividade recente
  static void _addRecentActivity(String activity) {
    _recentActivities.insert(0, activity);
    _saveRecentActivities();
  }

  /// Adiciona XP e verifica se subiu de nível
  static Future<void> addXP(int xp, String source) async {
    if (_currentStats == null) await initialize();
    if (_currentStats == null) return;

    final oldLevel = _currentStats!.level;
    _currentStats = _currentStats!.copyWith(
      totalXP: _currentStats!.totalXP + xp,
      lastActivity: DateTime.now(),
    );

    // Verifica se subiu de nível
    final newLevel = _calculateLevel(_currentStats!.totalXP);
    if (newLevel > oldLevel) {
      _currentStats = _currentStats!.copyWith(level: newLevel);
      _addRecentActivity('🎉 Subiu para o nível $newLevel!');
    }

    _addRecentActivity('+$xp XP • $source');
    await _saveUserStats();
  }

  /// Calcula o nível baseado no XP total
  static int _calculateLevel(int totalXP) {
    int level = 1;
    int xpNeeded = 0;
    
    while (true) {
      xpNeeded += level * 200;
      if (totalXP >= xpNeeded) {
        level++;
      } else {
        break;
      }
    }
    
    return level;
  }

  /// Registra conclusão de uma rota
  static Future<void> completeRoute(String routeName) async {
    if (_currentStats == null) await initialize();
    if (_currentStats == null) return;

    _currentStats = _currentStats!.copyWith(
      routesCompleted: _currentStats!.routesCompleted + 1,
      lastActivity: DateTime.now(),
    );

    await addXP(50, 'Completou a rota "$routeName"');
    await _updateBadgeProgress(BadgeType.exploration, 1);
    await _updateBadgeProgress(BadgeType.completion, 1);
    
    // Badge especial da primeira rota
    if (_currentStats!.routesCompleted == 1) {
      await _updateBadgeProgress('first_route', 1);
    }

    await _saveUserStats();
  }

  /// Registra escrita de uma avaliação
  static Future<void> writeReview() async {
    if (_currentStats == null) await initialize();
    if (_currentStats == null) return;

    _currentStats = _currentStats!.copyWith(
      reviewsWritten: _currentStats!.reviewsWritten + 1,
      lastActivity: DateTime.now(),
    );

    await addXP(20, 'Escreveu uma avaliação');
    await _updateBadgeProgress(BadgeType.social, 1);
    
    await _saveUserStats();
  }

  /// Registra compartilhamento de uma rota
  static Future<void> shareRoute() async {
    if (_currentStats == null) await initialize();
    if (_currentStats == null) return;

    _currentStats = _currentStats!.copyWith(
      sharesDone: _currentStats!.sharesDone + 1,
      lastActivity: DateTime.now(),
    );

    await addXP(10, 'Compartilhou uma rota');
    await _updateBadgeProgress(BadgeType.sharing, 1);
    
    await _saveUserStats();
  }

  /// Atualiza o progresso de uma badge
  static Future<void> _updateBadgeProgress(dynamic badgeIdentifier, int increment) async {
    for (int i = 0; i < _allBadges.length; i++) {
      final badge = _allBadges[i];
      
      final shouldUpdate = badgeIdentifier is BadgeType 
          ? badge.type == badgeIdentifier
          : badge.id == badgeIdentifier;
      
      if (shouldUpdate && !badge.unlocked) {
        final newValue = badge.currentValue + increment;
        final unlocked = newValue >= badge.targetValue;
        
        _allBadges[i] = badge.copyWith(
          currentValue: newValue,
          unlocked: unlocked,
          unlockDate: unlocked ? DateTime.now() : badge.unlockDate,
        );

        if (unlocked) {
          _currentStats = _currentStats!.copyWith(
            badgesUnlocked: _currentStats!.badgesUnlocked + 1,
          );
          _addRecentActivity('🏆 Conquista desbloqueada: ${badge.title}');
        }
      }
    }
    
    await _saveBadgesProgress();
    await _saveUserStats();
  }

  /// Obtém as estatísticas atuais do usuário
  static UserStats? get currentStats => _currentStats;

  /// Obtém todas as badges
  static List<Badge> get allBadges => _allBadges;

  /// Obtém badges desbloqueadas
  static List<Badge> get unlockedBadges {
    return _allBadges.where((badge) => badge.unlocked).toList();
  }

  /// Obtém badges bloqueadas
  static List<Badge> get lockedBadges {
    return _allBadges.where((badge) => !badge.unlocked).toList();
  }

  /// Obtém atividades recentes
  static List<String> get recentActivities => _recentActivities;

  /// Obtém badges por tipo
  static List<Badge> getBadgesByType(BadgeType type) {
    return _allBadges.where((badge) => badge.type == type).toList();
  }

  /// Reseta todas as estatísticas (apenas para desenvolvimento)
  static Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userStatsKey);
    await prefs.remove(_badgesKey);
    await prefs.remove(_activitiesKey);
    
    _currentStats = null;
    _allBadges = [];
    _recentActivities = [];
    
    await initialize();
  }

  // Métodos auxiliares para parse de JSON
  static Map<String, dynamic> _parseJsonString(String jsonString) {
    // Implementação simplificada para exemplo
    // Em app real, usar jsonDecode do dart:convert
    try {
      final Map<String, dynamic> result = {};
      final cleaned = jsonString.replaceAll('{', '').replaceAll('}', '');
      final pairs = cleaned.split(',');
      
      for (final pair in pairs) {
        final keyValue = pair.split(':');
        if (keyValue.length == 2) {
          final key = keyValue[0].trim().replaceAll('"', '');
          final value = keyValue[1].trim().replaceAll('"', '');
          
          // Conversão básica de tipos
          if (key == 'totalXP' || key == 'level' || key == 'routesCompleted' || 
              key == 'reviewsWritten' || key == 'sharesDone' || key == 'badgesUnlocked') {
            result[key] = int.tryParse(value) ?? 0;
          } else {
            result[key] = value;
          }
        }
      }
      return result;
    } catch (e) {
      return {};
    }
  }

  static List<Map<String, dynamic>> _parseJsonList(String jsonList) {
    // Implementação simplificada
    try {
      final List<Map<String, dynamic>> result = [];
      final items = jsonList.split('},{');
      
      for (final item in items) {
        final cleaned = item.replaceAll('[', '').replaceAll(']', '').replaceAll('{', '').replaceAll('}', '');
        final Map<String, dynamic> map = {};
        final pairs = cleaned.split(',');
        
        for (final pair in pairs) {
          final keyValue = pair.split(':');
          if (keyValue.length == 2) {
            final key = keyValue[0].trim().replaceAll('"', '');
            var value = keyValue[1].trim().replaceAll('"', '');
            
            // Conversão de tipos
            if (key == 'targetValue' || key == 'currentValue') {
              map[key] = int.tryParse(value) ?? 0;
            } else if (key == 'unlocked') {
              map[key] = value.toLowerCase() == 'true';
            } else {
              map[key] = value;
            }
          }
        }
        result.add(map);
      }
      return result;
    } catch (e) {
      return [];
    }
  }
}