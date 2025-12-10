import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Serviço para gerenciamento de avaliações e comentários das rotas
/// Armazena avaliações localmente usando SharedPreferences
class ReviewService {
  static const String _reviewsKey = 'route_reviews';
  static const String _userNameKey = 'user_display_name';

  /// Adiciona uma nova avaliação para uma rota
  static Future<void> addReview({
    required String routeId,
    required String user,
    required String comment,
    required double rating,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_reviewsKey);
    final Map<String, dynamic> reviewsMap = existing != null ? jsonDecode(existing) : {};

    final newReview = {
      'user': user,
      'comment': comment,
      'rating': rating,
      'date': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final List<dynamic> routeReviews = (reviewsMap[routeId] ?? []);
    
    // Remove avaliação existente do mesmo usuário (se houver)
    routeReviews.removeWhere((review) => review['user'] == user);
    
    // Adiciona a nova avaliação no início
    routeReviews.insert(0, newReview);
    reviewsMap[routeId] = routeReviews;

    await prefs.setString(_reviewsKey, jsonEncode(reviewsMap));
    
    // Salva o nome do usuário para uso futuro
    await prefs.setString(_userNameKey, user);

    // Após adicionar a review com sucesso:
    await GamificationService.writeReview();
  }

  /// Obtém todas as avaliações de uma rota
  static Future<List<Map<String, dynamic>>> getReviews(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_reviewsKey);
    if (existing == null) return [];
    
    final Map<String, dynamic> reviewsMap = jsonDecode(existing);
    final List<dynamic> reviews = reviewsMap[routeId] ?? [];
    
    // Converte para List<Map> e ordena por data (mais recente primeiro)
    return List<Map<String, dynamic>>.from(reviews)
      ..sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      });
  }

  /// Obtém a avaliação média de uma rota
  static Future<double> getAverageRating(String routeId) async {
    final reviews = await getReviews(routeId);
    if (reviews.isEmpty) return 0.0;
    
    final total = reviews.fold(0.0, (sum, review) => sum + (review['rating'] ?? 0.0));
    return total / reviews.length;
  }

  /// Obtém a contagem de avaliações de uma rota
  static Future<int> getReviewCount(String routeId) async {
    final reviews = await getReviews(routeId);
    return reviews.length;
  }

  /// Verifica se o usuário atual já avaliou uma rota
  static Future<bool> hasUserReviewed(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString(_userNameKey);
    if (userName == null) return false;

    final reviews = await getReviews(routeId);
    return reviews.any((review) => review['user'] == userName);
  }

  /// Obtém a avaliação do usuário atual para uma rota
  static Future<Map<String, dynamic>?> getUserReview(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString(_userNameKey);
    if (userName == null) return null;

    final reviews = await getReviews(routeId);
    return reviews.firstWhere(
      (review) => review['user'] == userName,
      orElse: () => <String, dynamic>{},
    );
  }

  /// Obtém o nome do usuário atual
  static Future<String> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? 'Viajante Tapioca';
  }

  /// Obtém estatísticas de avaliações para uma rota
  static Future<Map<String, dynamic>> getReviewStats(String routeId) async {
    final reviews = await getReviews(routeId);
    if (reviews.isEmpty) {
      return {
        'averageRating': 0.0,
        'reviewCount': 0,
        'ratingDistribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      };
    }

    // Calcula distribuição de avaliações
    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalRating = 0.0;

    for (final review in reviews) {
      final rating = (review['rating'] as num).toInt();
      if (rating >= 1 && rating <= 5) {
        distribution[rating] = distribution[rating]! + 1;
      }
      totalRating += review['rating'];
    }

    return {
      'averageRating': totalRating / reviews.length,
      'reviewCount': reviews.length,
      'ratingDistribution': distribution,
    };
  }

  /// Remove todas as avaliações (apenas para desenvolvimento)
  static Future<void> clearAllReviews() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reviewsKey);
  }
}