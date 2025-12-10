import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling offline data storage
/// Uses shared_preferences and file storage for offline content
class OfflineStorageService {
  static const String _downloadedRoutesKey = 'downloaded_routes';
  
  /// Check if a route is available offline
  Future<bool> isRouteDownloaded(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedRoutes = prefs.getStringList(_downloadedRoutesKey) ?? [];
    return downloadedRoutes.contains(routeId);
  }
  
  /// Mark route as downloaded for offline use
  Future<void> markRouteAsDownloaded(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedRoutes = prefs.getStringList(_downloadedRoutesKey) ?? [];
    
    if (!downloadedRoutes.contains(routeId)) {
      downloadedRoutes.add(routeId);
      await prefs.setStringList(_downloadedRoutesKey, downloadedRoutes);
    }
  }
  
  /// Get list of downloaded route IDs
  Future<List<String>> getDownloadedRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_downloadedRoutesKey) ?? [];
  }
  
  /// Remove route from offline storage
  Future<void> removeOfflineRoute(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedRoutes = prefs.getStringList(_downloadedRoutesKey) ?? [];
    downloadedRoutes.remove(routeId);
    await prefs.setStringList(_downloadedRoutesKey, downloadedRoutes);
    
    // TODO: Remove associated files (audio, images)
  }
  
  /// Clear all offline data
  Future<void> clearAllOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_downloadedRoutesKey);
    
    // TODO: Clear all downloaded files
  }
}