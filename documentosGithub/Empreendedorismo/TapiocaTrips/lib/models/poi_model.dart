/// Modelo de Ponto de Interesse (POI) para o sistema de narrativas
/// Extende o modelo existente com funcionalidades de áudio e geolocalização
class PointOfInterest {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String? audioStoryUrl;
  final String? imageUrl;
  final int? estimatedVisitTime;
  final String? category;
  final bool? hasAccessibility;
  final String? localTip;
  final int? orderInRoute;
  
  // NOVOS CAMPOS PARA NARRATIVAS
  final String? localAudioPath; // Caminho local do arquivo de áudio
  final double audioDuration; // Duração em segundos
  final String narratorName; // Nome do narrador local
  final bool isAudioDownloaded; // Se o áudio está baixado localmente
  final DateTime? lastPlayed; // Quando foi reproduzido pela última vez

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
    
    // Novos campos com valores padrão
    this.localAudioPath,
    this.audioDuration = 0.0,
    this.narratorName = 'Morador Local',
    this.isAudioDownloaded = false,
    this.lastPlayed,
  });

  /// Cria um PointOfInterest a partir de JSON
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
      
      // Novos campos
      localAudioPath: json['localAudioPath']?.toString(),
      audioDuration: json['audioDuration'] is double 
          ? json['audioDuration'] as double
          : (json['audioDuration'] is String 
              ? double.tryParse(json['audioDuration'] as String) ?? 0.0
              : 0.0),
      narratorName: json['narratorName']?.toString() ?? 'Morador Local',
      isAudioDownloaded: json['isAudioDownloaded'] is bool 
          ? json['isAudioDownloaded'] as bool
          : (json['isAudioDownloaded'] is String 
              ? (json['isAudioDownloaded'] as String).toLowerCase() == 'true'
              : false),
      lastPlayed: json['lastPlayed'] is String 
          ? DateTime.tryParse(json['lastPlayed'] as String)
          : null,
    );
  }

  /// Converte PointOfInterest para JSON
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
      
      // Novos campos
      'localAudioPath': localAudioPath,
      'audioDuration': audioDuration,
      'narratorName': narratorName,
      'isAudioDownloaded': isAudioDownloaded,
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }

  /// Cria uma cópia do PointOfInterest com campos atualizados
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
    String? localAudioPath,
    double? audioDuration,
    String? narratorName,
    bool? isAudioDownloaded,
    DateTime? lastPlayed,
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
      localAudioPath: localAudioPath ?? this.localAudioPath,
      audioDuration: audioDuration ?? this.audioDuration,
      narratorName: narratorName ?? this.narratorName,
      isAudioDownloaded: isAudioDownloaded ?? this.isAudioDownloaded,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  /// Marca o áudio como baixado
  PointOfInterest markAsDownloaded(String audioPath) {
    return copyWith(
      localAudioPath: audioPath,
      isAudioDownloaded: true,
    );
  }

  /// Marca como reproduzido
  PointOfInterest markAsPlayed() {
    return copyWith(lastPlayed: DateTime.now());
  }

  /// Verifica se o POI tem áudio disponível
  bool get hasAudio {
    return audioStoryUrl != null && audioStoryUrl!.isNotEmpty;
  }

  /// Verifica se o áudio está disponível offline
  bool get isAudioAvailableOffline {
    return isAudioDownloaded && localAudioPath != null;
  }

  /// Retorna a duração formatada do áudio
  String get formattedDuration {
    final duration = Duration(seconds: audioDuration.toInt());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'PointOfInterest(id: $id, name: $name, hasAudio: $hasAudio, offline: $isAudioAvailableOffline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PointOfInterest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Status de reprodução do áudio
enum AudioPlaybackStatus {
  stopped,
  playing,
  paused,
  loading,
  error,
}

/// Evento de proximidade geográfica
class ProximityEvent {
  final PointOfInterest poi;
  final double distance; // em metros
  final DateTime timestamp;

  const ProximityEvent({
    required this.poi,
    required this.distance,
    required this.timestamp,
  });

  /// Verifica se está próximo o suficiente para sugerir áudio
  bool get shouldSuggestAudio {
    return distance <= 50.0; // 50 metros
  }

  /// Retorna descrição da distância
  String get distanceDescription {
    if (distance < 10) return 'Bem próximo';
    if (distance < 25) return 'Próximo';
    if (distance < 50) return 'Perto';
    if (distance < 100) return 'Um pouco longe';
    return 'Longe';
  }
}