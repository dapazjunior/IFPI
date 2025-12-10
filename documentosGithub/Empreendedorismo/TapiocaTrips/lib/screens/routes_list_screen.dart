import 'package:flutter/material.dart';
import 'route_detail_screen.dart';
import '../models/route_model.dart';
import '../services/data_service.dart';
import '../utils/theme.dart';

/// Routes List Screen - Displays available tourism routes with rich visuals
/// Features cultural imagery, smooth animations, and local Piauí identity
class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  final DataService _dataService = DataService();
  late Future<List<TourismRoute>> _routesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _routesFuture = _loadRoutes();
  }

  /// Load routes from DataService with error handling
  Future<List<TourismRoute>> _loadRoutes() async {
    try {
      return await _dataService.getRoutes();
    } catch (e) {
      // Fallback to mock data if service fails
      return _getMockRoutes();
    }
  }

  /// Mock data representing Piauí's diverse landscapes and cultural routes
  List<TourismRoute> _getMockRoutes() {
    return [
      TourismRoute(
        id: '1',
        title: 'Delta do Parnaíba',
        description: 'Explore o único delta em mar aberto das Américas com seus manguezais, dunas e igarapés',
        duration: '6 horas',
        distance: '25 km',
        imageUrl: 'delta_parnaiba',
        difficulty: 'Moderado',
        category: 'Natureza',
      ),
      TourismRoute(
        id: '2',
        title: 'Serra da Capivara',
        description: 'Sítios arqueológicos com pinturas rupestres milenares em meio à caatinga preservada',
        duration: '8 horas',
        distance: '12 km',
        imageUrl: 'serra_capivara',
        difficulty: 'Fácil',
        category: 'Cultural',
      ),
      TourismRoute(
        id: '3',
        title: 'Rota das Emoções - Piauí',
        description: 'Dunas, lagoas e praias desertas no litoral mais preservado do Nordeste',
        duration: '4 horas',
        distance: '18 km',
        imageUrl: 'rota_emocoes',
        difficulty: 'Moderado',
        category: 'Aventura',
      ),
      TourismRoute(
        id: '4',
        title: 'Teresina Histórica',
        description: 'Centro cultural, mercados tradicionais e arquitetura do século XIX na capital',
        duration: '3 horas',
        distance: '4 km',
        imageUrl: 'teresina_historica',
        difficulty: 'Fácil',
        category: 'Cultural',
      ),
      TourismRoute(
        id: '5',
        title: 'Cânion do Rio Poti',
        description: 'Formações rochosas impressionantes e trilhas pela caatinga no sul do estado',
        duration: '5 horas',
        distance: '8 km',
        imageUrl: 'canion_poti',
        difficulty: 'Difícil',
        category: 'Aventura',
      ),
    ];
  }

  /// Get gradient background based on route category
  List<Color> _getCategoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'natureza':
        return [const Color(0xFF2E7D32), const Color(0xFF4CAF50)];
      case 'cultural':
        return [const Color(0xFFFF9800), const Color(0xFFFFB74D)];
      case 'aventura':
        return [const Color(0xFFF44336), const Color(0xFFEF5350)];
      default:
        return [AppTheme.sustainableGreen, AppTheme.culturalOrange];
    }
  }

  /// Get icon based on route category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'natureza':
        return Icons.eco_rounded;
      case 'cultural':
        return Icons.account_balance_rounded;
      case 'aventura':
        return Icons.landscape_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  /// Navigate to route details with custom animation
  void _navigateToRouteDetails(TourismRoute route) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RouteDetailScreen(route: route),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  /// Show offline download placeholder
  void _showDownloadAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download_rounded, color: Colors.blue),
            SizedBox(width: 12),
            Text('Download Offline'),
          ],
        ),
        content: const Text(
          'Em breve você poderá baixar todas as rotas para explorar sem conexão com a internet. '
          'Isso incluirá mapas, áudios e informações detalhadas de cada rota.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  /// Build individual route card with cultural design
  Widget _buildRouteCard(TourismRoute route, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToRouteDetails(route),
          splashColor: AppTheme.culturalOrange.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card header with gradient and category
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getCategoryGradient(route.category ?? 'Natureza'),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    // Category badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(route.category ?? 'Natureza'),
                              size: 14,
                              color: _getCategoryGradient(route.category ?? 'Natureza')[0],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              route.category ?? 'Natureza',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Route title overlay
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        route.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      route.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Route metrics
                    Row(
                      children: [
                        _buildMetricChip(
                          Icons.schedule_rounded,
                          route.duration,
                          Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildMetricChip(
                          Icons.alt_route_rounded,
                          route.distance,
                          Colors.green,
                        ),
                        const SizedBox(width: 8),
                        _buildMetricChip(
                          Icons.terrain_rounded,
                          route.difficulty ?? 'Moderado',
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToRouteDetails(route),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sustainableGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.explore_rounded, size: 18),
                        label: const Text(
                          'Explorar Rota',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build metric chip for duration, distance, difficulty
  Widget _buildMetricChip(IconData icon, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with gradient background
      appBar: AppBar(
        title: const Text(
          'Rotas do Piauí',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF2E7D32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      // Floating action button for offline download
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDownloadAllDialog,
        backgroundColor: AppTheme.culturalOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.download_rounded),
        label: const Text('Download All'),
        elevation: 4,
      ),
      // Main content
      body: FutureBuilder<List<TourismRoute>>(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorState();
          }

          final routes = snapshot.data!;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: ListView.builder(
              itemCount: routes.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                return _buildRouteCard(routes[index], index);
              },
            ),
          );
        },
      ),
    );
  }

  /// Build loading shimmer effect
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  /// Build error state with retry option
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar rotas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar as rotas disponíveis.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _routesFuture = _loadRoutes();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}