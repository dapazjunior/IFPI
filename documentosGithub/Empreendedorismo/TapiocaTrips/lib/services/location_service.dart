/// Serviço mock para simular localização do usuário
/// Em uma implementação real, integraria com GPS do dispositivo
class LocationService {
  
  /// Simula obtenção da localização atual do usuário
  /// Retorna coordenadas mock de Teresina, Piauí
  Future<Map<String, double>> getCurrentLocation() async {
    // Simula delay de GPS
    await Future.delayed(const Duration(milliseconds: 500));
    
    return {
      'latitude': -5.0892,  // Teresina, PI
      'longitude': -42.8016,
    };
  }
  
  /// Calcula distância entre duas coordenadas (simplificado)
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Implementação simplificada para mock
    // Em app real, usaríamos fórmula de Haversine
    final latDiff = (lat1 - lat2).abs();
    final lngDiff = (lng1 - lng2).abs();
    return (latDiff + lngDiff) * 111.0; // Aproximação em km
  }
  
  /// Verifica se localização está próxima (em metros)
  bool isNearby(double userLat, double userLng, double poiLat, double poiLng, 
                {double radiusKm = 10.0}) {
    final distance = calculateDistance(userLat, userLng, poiLat, poiLng);
    return distance <= radiusKm;
  }
}