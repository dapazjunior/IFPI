/// Data model representing a tourism route in Tapioca Trips
/// Contains all information needed to display and navigate routes
class TourismRoute {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String distance;
  final String? imageUrl;
  final String? difficulty;
  final String? category;
  final List<PointOfInterest>? pointsOfInterest;
  final String? audioIntroductionUrl;
  final double? rating;
  final int? reviewCount;
  final bool? isPremium;
  final bool? isDownloaded;
  final DateTime? lastUpdated;

  const TourismRoute({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.distance,
    this.imageUrl,
    this.difficulty,
    this.category,
    this.pointsOfInterest,
    this.audioIntroductionUrl,
    this.rating,
    this.reviewCount,
    this.isPremium,
    this.isDownloaded,
    this.lastUpdated,
  });

  /// Creates a TourismRoute from JSON data
  /// Used for parsing API responses and local storage
  factory TourismRoute.fromJson(Map<String, dynamic> json) {
    return TourismRoute(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      difficulty: json['difficulty']?.toString(),
      category: json['category']?.toString(),
      audioIntroductionUrl: json['audioIntroductionUrl']?.toString(),
      rating: json['rating'] is double 
          ? json['rating'] as double
          : (json['rating'] is int 
              ? (json['rating'] as int).toDouble()
              : null),
      reviewCount: json['reviewCount'] is int 
          ? json['reviewCount'] as int
          : (json['reviewCount'] is String 
              ? int.tryParse(json['reviewCount'] as String)
              : null),
      isPremium: json['isPremium'] is bool 
          ? json['isPremium'] as bool
          : (json['isPremium'] is String 
              ? (json['isPremium'] as String).toLowerCase() == 'true'
              : false),
      isDownloaded: json['isDownloaded'] is bool 
          ? json['isDownloaded'] as bool
          : (json['isDownloaded'] is String 
              ? (json['isDownloaded'] as String).toLowerCase() == 'true'
              : false),
      lastUpdated: json['lastUpdated'] is String 
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
      pointsOfInterest: json['pointsOfInterest'] is List
          ? (json['pointsOfInterest'] as List)
              .map((poiJson) => PointOfInterest.fromJson(poiJson))
              .toList()
          : null,
    );
  }

  /// Converts TourismRoute to JSON for storage and API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'distance': distance,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'category': category,
      'audioIntroductionUrl': audioIntroductionUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPremium': isPremium,
      'isDownloaded': isDownloaded,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'pointsOfInterest': pointsOfInterest?.map((poi) => poi.toJson()).toList(),
    };
  }

  /// Creates a copy of the TourismRoute with updated fields
  /// Useful for state management and updates
  TourismRoute copyWith({
    String? id,
    String? title,
    String? description,
    String? duration,
    String? distance,
    String? imageUrl,
    String? difficulty,
    String? category,
    List<PointOfInterest>? pointsOfInterest,
    String? audioIntroductionUrl,
    double? rating,
    int? reviewCount,
    bool? isPremium,
    bool? isDownloaded,
    DateTime? lastUpdated,
  }) {
    return TourismRoute(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      pointsOfInterest: pointsOfInterest ?? this.pointsOfInterest,
      audioIntroductionUrl: audioIntroductionUrl ?? this.audioIntroductionUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPremium: isPremium ?? this.isPremium,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Returns a string representation for debugging
  @override
  String toString() {
    return 'TourismRoute(id: $id, title: $title, category: $category, difficulty: $difficulty)';
  }

  /// Equality check based on ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TourismRoute && other.id == id;
  }

  /// Hash code based on ID for use in collections
  @override
  int get hashCode => id.hashCode;
}

/// Data model representing a Point of Interest within a route
/// Contains location data, audio stories, and cultural information
class PointOfInterest {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String? audioStoryUrl;
  final String? imageUrl;
  final int? estimatedVisitTime; // in minutes
  final String? category;
  final bool? hasAccessibility;
  final String? localTip;
  final int? orderInRoute;

  const PointOfInterest({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.audioStoryUrl,
    this.imageUrl,
    this.estimatedVisitTime,
    this.category,
    this.hasAccessibility,
    this.localTip,
    this.orderInRoute,
  });

  /// Creates a PointOfInterest from JSON data
  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    return PointOfInterest(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      latitude: json['latitude'] is double 
          ? json['latitude'] as double
          : (json['latitude'] is String 
              ? double.tryParse(json['latitude'] as String) ?? 0.0
              : 0.0),
      longitude: json['longitude'] is double 
          ? json['longitude'] as double
          : (json['longitude'] is String 
              ? double.tryParse(json['longitude'] as String) ?? 0.0
              : 0.0),
      audioStoryUrl: json['audioStoryUrl']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      estimatedVisitTime: json['estimatedVisitTime'] is int 
          ? json['estimatedVisitTime'] as int
          : (json['estimatedVisitTime'] is String 
              ? int.tryParse(json['estimatedVisitTime'] as String)
              : null),
      category: json['category']?.toString(),
      hasAccessibility: json['hasAccessibility'] is bool 
          ? json['hasAccessibility'] as bool
          : (json['hasAccessibility'] is String 
              ? (json['hasAccessibility'] as String).toLowerCase() == 'true'
              : null),
      localTip: json['localTip']?.toString(),
      orderInRoute: json['orderInRoute'] is int 
          ? json['orderInRoute'] as int
          : (json['orderInRoute'] is String 
              ? int.tryParse(json['orderInRoute'] as String)
              : null),
    );
  }

  /// Converts PointOfInterest to JSON for storage and API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'audioStoryUrl': audioStoryUrl,
      'imageUrl': imageUrl,
      'estimatedVisitTime': estimatedVisitTime,
      'category': category,
      'hasAccessibility': hasAccessibility,
      'localTip': localTip,
      'orderInRoute': orderInRoute,
    };
  }

  /// Creates a copy of the PointOfInterest with updated fields
  PointOfInterest copyWith({
    String? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? audioStoryUrl,
    String? imageUrl,
    int? estimatedVisitTime,
    String? category,
    bool? hasAccessibility,
    String? localTip,
    int? orderInRoute,
  }) {
    return PointOfInterest(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      audioStoryUrl: audioStoryUrl ?? this.audioStoryUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      estimatedVisitTime: estimatedVisitTime ?? this.estimatedVisitTime,
      category: category ?? this.category,
      hasAccessibility: hasAccessibility ?? this.hasAccessibility,
      localTip: localTip ?? this.localTip,
      orderInRoute: orderInRoute ?? this.orderInRoute,
    );
  }

  /// Returns a string representation for debugging
  @override
  String toString() {
    return 'PointOfInterest(id: $id, name: $name, lat: $latitude, lng: $longitude)';
  }

  /// Equality check based on ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PointOfInterest && other.id == id;
  }

  /// Hash code based on ID for use in collections
  @override
  int get hashCode => id.hashCode;
}

/// Extension methods for TourismRoute utilities
extension TourismRouteExtensions on TourismRoute {
  /// Returns the total estimated time in minutes
  int? get totalMinutes {
    final durationParts = duration.split(' ');
    if (durationParts.isNotEmpty) {
      final value = int.tryParse(durationParts[0]);
      if (durationParts[1].toLowerCase().contains('hora')) {
        return value != null ? value * 60 : null;
      }
      return value;
    }
    return null;
  }

  /// Returns the total distance in kilometers
  double? get distanceInKm {
    final distanceParts = distance.split(' ');
    if (distanceParts.isNotEmpty) {
      return double.tryParse(distanceParts[0]);
    }
    return null;
  }

  /// Checks if the route is suitable for beginners
  bool get isBeginnerFriendly {
    return difficulty?.toLowerCase().contains('fácil') == true ||
        difficulty?.toLowerCase().contains('easy') == true;
  }

  /// Returns the number of points of interest
  int get pointsOfInterestCount {
    return pointsOfInterest?.length ?? 0;
  }

  /// Returns the first image URL for the route
  String? get displayImageUrl {
    return imageUrl ?? pointsOfInterest?.firstOrNull?.imageUrl;
  }
}

/// Extension methods for List operations
extension PointOfInterestListExtensions on List<PointOfInterest> {
  /// Gets the first point of interest or null if empty
  PointOfInterest? get firstOrNull => isEmpty ? null : first;

  /// Gets points of interest by category
  List<PointOfInterest> getByCategory(String category) {
    return where((poi) => poi.category == category).toList();
  }

  /// Gets points of interest with audio stories
  List<PointOfInterest> getWithAudioStories() {
    return where((poi) => poi.audioStoryUrl != null && poi.audioStoryUrl!.isNotEmpty).toList();
  }

  /// Gets points of interest with accessibility
  List<PointOfInterest> getAccessiblePoints() {
    return where((poi) => poi.hasAccessibility == true).toList();
  }
}