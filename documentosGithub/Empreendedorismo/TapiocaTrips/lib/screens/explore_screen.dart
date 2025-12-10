import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/components/poi_marker_widget.dart';
import 'package:tapioca_trips/components/explore_filter_bar.dart';
import 'package:tapioca_trips/services/location_service.dart';

/// Tela principal de exploração interativa do Tapioca Trips
/// Exibe mapa com pontos de interesse, filtros e sistema de descoberta
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Serviço de localização mock
  final LocationService _locationService = LocationService();
  
  // Lista de pontos de interesse
  final List<POI> _pointsOfInterest = [];
  
  // Filtros ativos
  Set<String> _activeFilters = {};
  
  // POI selecionado no mapa
  POI? _selectedPOI;
  
  // Controlador do painel inferior
  final DraggableScrollableController _panelController = DraggableScrollableController();
  
  // Estado de carregamento
  bool _isLoading = true;
  
  // Localização atual do usuário
  Map<String, double>? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Inicializa dados mock e simula carregamento
  void _initializeData() async {
    // Simula delay de carregamento
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Obtém localização atual
    _currentLocation = await _locationService.getCurrentLocation();
    
    // Carrega pontos de interesse mock
    _pointsOfInterest.addAll([
      POI(
        name: "Porto das Barcas",
        category: "Cultural",
        lat: -5.0892,
        lng: -42.8016,
        description: "Centro histórico com arquitetura colonial e comércio local",
        rating: 4.7,
        distance: 0.8,
      ),
      POI(
        name: "Delta do Parnaíba",
        category: "Natureza",
        lat: -2.7489,
        lng: -41.8301,
        description: "Único delta em mar aberto das Américas, com paisagens deslumbrantes",
        rating: 4.9,
        distance: 12.5,
      ),
      POI(
        name: "Praia de Luís Correia",
        category: "Sustentável",
        lat: -2.8804,
        lng: -41.6664,
        description: "Praia preservada com iniciativas de turismo sustentável",
        rating: 4.5,
        distance: 15.2,
      ),
      POI(
        name: "Mercado Público",
        category: "Gastronomia",
        lat: -5.0881,
        lng: -42.7998,
        description: "Mercado tradicional com comidas típicas e artesanato",
        rating: 4.3,
        distance: 1.2,
      ),
      POI(
        name: "Parque Nacional de Sete Cidades",
        category: "Natureza",
        lat: -4.1000,
        lng: -41.7167,
        description: "Formações rochosas únicas com pinturas rupestres",
        rating: 4.8,
        distance: 45.0,
      ),
      POI(
        name: "Cachoeira do Urubu",
        category: "Natureza",
        lat: -5.2000,
        lng: -42.9000,
        description: "Belíssima cachoeira com piscinas naturais",
        rating: 4.6,
        distance: 28.3,
      ),
    ]);
    
    setState(() {
      _isLoading = false;
    });
  }

  /// Aplica filtros de categoria
  void _applyFilters(Set<String> filters) {
    setState(() {
      _activeFilters = filters;
    });
  }

  /// Seleciona um ponto no mapa
  void _selectPOI(POI poi) {
    setState(() {
      _selectedPOI = poi;
    });
    
    // Expande o painel quando um POI é selecionado
    _panelController.animateTo(0.4,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
    
    // Mostra feedback de descoberta (simulado)
    _showDiscoveryFeedback(poi);
  }

  /// Mostra feedback de descoberta com XP
  void _showDiscoveryFeedback(POI poi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.sustainableGreen,
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "🎉 ${poi.name} descoberto! +10 XP",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Filtra POIs baseado nos filtros ativos
  List<POI> get _filteredPOIs {
    if (_activeFilters.isEmpty) return _pointsOfInterest;
    return _pointsOfInterest
        .where((poi) => _activeFilters.contains(poi.category))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingState()
          : _buildExploreContent(),
      floatingActionButton: _buildExploreNearbyButton(),
    );
  }

  /// Conteúdo principal da tela de exploração
  Widget _buildExploreContent() {
    return Stack(
      children: [
        // Mapa (placeholder interativo)
        _buildMapPlaceholder(),
        
        // Barra superior com filtros
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: ExploreFilterBar(
            onFiltersChanged: _applyFilters,
            activeFilters: _activeFilters,
          ),
        ),
        
        // Painel inferior deslizante
        _buildBottomSheet(),
      ],
    );
  }

  /// Placeholder do mapa com marcadores interativos
  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.sustainableGreen.withOpacity(0.3),
            AppTheme.culturalOrange.withOpacity(0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Mapa de fundo estilizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: AppTheme.sustainableGreen.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mapa Tapioca Trips',
                  style: TextStyle(
                    color: AppTheme.sustainableGreen.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '🌎 Explorando o Piauí',
                  style: TextStyle(
                    color: AppTheme.culturalOrange.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Marcadores dos POIs
          ..._filteredPOIs.map((poi) => Positioned(
            left: (poi.lng + 43.0) * MediaQuery.of(context).size.width / 2.0,
            top: (poi.lat + 6.0) * MediaQuery.of(context).size.height / 12.0,
            child: GestureDetector(
              onTap: () => _selectPOI(poi),
              child: POIMarkerWidget(
                poi: poi,
                isSelected: _selectedPOI == poi,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  /// Painel inferior deslizante com lista de locais
  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _panelController,
      initialChildSize: 0.25,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      snap: true,
      snapSizes: const [0.25, 0.5, 0.7],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Alça do painel
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Título do painel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Locais Próximos',
                      style: TextStyle(
                        color: AppTheme.sustainableGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.culturalOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_filteredPOIs.length}',
                        style: TextStyle(
                          color: AppTheme.culturalOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Lista de locais
              Expanded(
                child: _filteredPOIs.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _filteredPOIs.length,
                        itemBuilder: (context, index) {
                          final poi = _filteredPOIs[index];
                          return _buildPOIListItem(poi);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Item da lista de POIs
  Widget _buildPOIListItem(POI poi) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(poi.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(poi.category),
            color: _getCategoryColor(poi.category),
            size: 20,
          ),
        ),
        title: Text(
          poi.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poi.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppTheme.culturalOrange,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  poi.rating.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on,
                  color: AppTheme.sustainableGreen,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  '${poi.distance} km',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
        onTap: () => _selectPOI(poi),
      ),
    );
  }

  /// Estado de carregamento
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.sustainableGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando mapa Tapioca...',
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Estado vazio quando não há POIs
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum local encontrado',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          Text(
            'Tente ajustar os filtros',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Botão flutuante para explorar próximos
  Widget _buildExploreNearbyButton() {
    return FloatingActionButton(
      onPressed: () {
        // Simula busca por locais próximos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🔄 Buscando experiências próximas...',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppTheme.sustainableGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      backgroundColor: AppTheme.culturalOrange,
      foregroundColor: Colors.white,
      child: const Icon(Icons.explore),
    );
  }

  /// Retorna cor baseada na categoria
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Cultural':
        return AppTheme.culturalOrange;
      case 'Natureza':
        return Colors.green;
      case 'Gastronomia':
        return Colors.red;
      case 'Sustentável':
        return AppTheme.sustainableGreen;
      default:
        return Colors.grey;
    }
  }

  /// Retorna ícone baseado na categoria
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cultural':
        return Icons.account_balance;
      case 'Natureza':
        return Icons.eco;
      case 'Gastronomia':
        return Icons.restaurant;
      case 'Sustentável':
        return Icons.leaf;
      default:
        return Icons.place;
    }
  }
}

/// Modelo de Ponto de Interesse
class POI {
  final String name;
  final String category;
  final double lat;
  final double lng;
  final String description;
  final double rating;
  final double distance;

  POI({
    required this.name,
    required this.category,
    required this.lat,
    required this.lng,
    required this.description,
    required this.rating,
    required this.distance,
  });
}