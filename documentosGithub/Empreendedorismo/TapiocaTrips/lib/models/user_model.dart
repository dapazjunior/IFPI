/// Modelo de perfil do usuário para Tapioca Trips
/// Armazena informações pessoais, favoritos e histórico de navegação
class UserProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> favoriteRouteIds;
  final List<String> recentlyViewedRoutes;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const UserProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.favoriteRouteIds = const [],
    this.recentlyViewedRoutes = const [],
    this.createdAt,
    this.lastLogin,
  });

  /// Cria um UserProfile a partir de JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Usuário Tapioca',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      favoriteRouteIds: List<String>.from(json['favoriteRouteIds'] ?? []),
      recentlyViewedRoutes: List<String>.from(json['recentlyViewedRoutes'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

  /// Converte UserProfile para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'favoriteRouteIds': favoriteRouteIds,
      'recentlyViewedRoutes': recentlyViewedRoutes,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Cria uma cópia do perfil com campos atualizados
  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    List<String>? favoriteRouteIds,
    List<String>? recentlyViewedRoutes,
    DateTime? lastLogin,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteRouteIds: favoriteRouteIds ?? this.favoriteRouteIds,
      recentlyViewedRoutes: recentlyViewedRoutes ?? this.recentlyViewedRoutes,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  /// Adiciona um favorito (sem modificar o objeto original)
  UserProfile addFavorite(String routeId) {
    final newFavorites = List<String>.from(favoriteRouteIds);
    if (!newFavorites.contains(routeId)) {
      newFavorites.add(routeId);
    }
    return copyWith(favoriteRouteIds: newFavorites);
  }

  /// Remove um favorito (sem modificar o objeto original)
  UserProfile removeFavorite(String routeId) {
    final newFavorites = List<String>.from(favoriteRouteIds);
    newFavorites.remove(routeId);
    return copyWith(favoriteRouteIds: newFavorites);
  }

  /// Adiciona uma rota ao histórico (sem modificar o objeto original)
  UserProfile addToRecentlyViewed(String routeId) {
    final newHistory = List<String>.from(recentlyViewedRoutes);
    
    // Remove se já existir (para evitar duplicatas)
    newHistory.remove(routeId);
    
    // Adiciona no início
    newHistory.insert(0, routeId);
    
    // Mantém apenas os últimos 10 itens
    if (newHistory.length > 10) {
      newHistory.removeRange(10, newHistory.length);
    }
    
    return copyWith(recentlyViewedRoutes: newHistory);
  }

  /// Limpa o histórico (sem modificar o objeto original)
  UserProfile clearHistory() {
    return copyWith(recentlyViewedRoutes: []);
  }

  /// Verifica se uma rota é favorita
  bool isFavorite(String routeId) {
    return favoriteRouteIds.contains(routeId);
  }

  @override
  String toString() {
    return 'UserProfile(name: $name, email: $email, favorites: ${favoriteRouteIds.length}, history: ${recentlyViewedRoutes.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}