/// App constants and configuration values
class AppConstants {
  static const String appName = 'Tapioca Trips';
  static const String appVersion = '1.0.0';
  
  // API endpoints (to be configured)
  static const String baseApiUrl = 'https://api.tapiocatrips.com';
  static const String routesEndpoint = '$baseApiUrl/routes';
  static const String audioEndpoint = '$baseApiUrl/audio';
  
  // Storage keys
  static const String firstLaunchKey = 'first_launch';
  static const String userPreferencesKey = 'user_preferences';
  
  // App settings
  static const double defaultMapZoom = 15.0;
  static const int downloadTimeoutSeconds = 60;
  
  // Supported languages
  static const List<String> supportedLanguages = ['pt', 'en'];
  
  // Feature flags
  static const bool enableOfflineMode = true;
  static const bool enableAudioStories = true;
}