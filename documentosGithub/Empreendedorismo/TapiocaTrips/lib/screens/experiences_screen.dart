import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/experience.dart';
import 'package:tapioca_trips/components/experience_card.dart';
import 'package:tapioca_trips/screens/experience_detail_screen.dart';

/// Tela principal de experiências interativas do Tapioca Trips
class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> 
    with SingleTickerProviderStateMixin {
  
  // Lista de experiências
  final List<Experience> _experiences = [];
  
  // Filtros ativos
  Set<String> _activeFilters = {};
  
  // Controlador de busca
  final TextEditingController _searchController = TextEditingController();
  
  // Estado de carregamento
  bool _isLoading = true;
  
  // Categorias disponíveis
  final List<ExperienceCategory> _categories = [
    ExperienceCategory(name: 'Todos', icon: Icons.all_inclusive, filter: 'all'),
    ExperienceCategory(name: 'Natureza', icon: Icons.eco, filter: 'Natureza'),
    ExperienceCategory(name: 'Cultural', icon: Icons.account_balance, filter: 'Cultural'),
    ExperienceCategory(name: 'Sustentável', icon: Icons.leaf, filter: 'Sustentável'),
    ExperienceCategory(name: 'Gastronomia', icon: Icons.restaurant, filter: 'Gastronomia'),
  ];

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  /// Carrega experiências mock
  void _loadExperiences() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _experiences.addAll(Experience.mockExperiences());
      _isLoading = false;
    });
  }

  /// Aplica filtro de categoria
  void _applyFilter(String filter) {
    setState(() {
      if (filter == 'all') {
        _activeFilters.clear();
      } else {
        _activeFilters = {filter};
      }
    });
  }

  /// Navega para tela de detalhes da experiência
  void _navigateToDetail(Experience experience) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExperienceDetailScreen(experience: experience),
      ),
    );
  }

  /// Filtra experiências baseado nos filtros ativos e busca
  List<Experience> get _filteredExperiences {
    var filtered = _experiences;

    // Aplica filtros de categoria
    if (_activeFilters.isNotEmpty) {
      filtered = filtered.where((exp) => _activeFilters.contains(exp.category)).toList();
    }

    // Aplica busca
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((exp) =>
        exp.title.toLowerCase().contains(query) ||
        exp.description.toLowerCase().contains(query) ||
        exp.location.toLowerCase().contains(query) ||
        exp.tags.any((tag) => tag.toLowerCase().contains(query))
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? _buildLoadingState()
          : _buildExperiencesContent(),
    );
  }

  /// Conteúdo principal da tela
  Widget _buildExperiencesContent() {
    return CustomScrollView(
      slivers: [
        // AppBar personalizada
        _buildExperiencesAppBar(),
        
        // Filtros de categoria
        _buildCategoryFilters(),
        
        // Lista de experiências
        _buildExperiencesList(),
      ],
    );
  }

  /// AppBar personalizada
  SliverAppBar _buildExperiencesAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      expandedHeight: 140,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Experiências Interativas',
                style: TextStyle(
                  color: AppTheme.sustainableGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Descubra trilhas, desafios e narrativas locais',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.sustainableGreen.withOpacity(0.1),
                AppTheme.culturalOrange.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Filtros de categoria
  SliverToBoxAdapter _buildCategoryFilters() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de busca
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar experiências...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            
            // Categorias
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isActive = category.filter == 'all' 
                      ? _activeFilters.isEmpty
                      : _activeFilters.contains(category.filter);
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.name),
                      avatar: Icon(
                        category.icon,
                        size: 16,
                        color: isActive ? Colors.white : AppTheme.sustainableGreen,
                      ),
                      selected: isActive,
                      onSelected: (_) => _applyFilter(category.filter),
                      backgroundColor: Colors.white,
                      selectedColor: AppTheme.sustainableGreen,
                      labelStyle: TextStyle(
                        color: isActive ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isActive ? AppTheme.sustainableGreen : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lista de experiências
  Widget _buildExperiencesList() {
    if (_filteredExperiences.isEmpty) {
      return _buildEmptyState();
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final experience = _filteredExperiences[index];
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: index == 0 ? 8 : 0,
            ),
            child: ExperienceCard(
              experience: experience,
              onTap: () => _navigateToDetail(experience),
            ),
          );
        },
        childCount: _filteredExperiences.length,
      ),
    );
  }

  /// Estado vazio
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
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
              'Nenhuma experiência encontrada',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou termos de busca',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
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
            'Carregando experiências...',
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo de categoria para filtros
class ExperienceCategory {
  final String name;
  final IconData icon;
  final String filter;

  ExperienceCategory({
    required this.name,
    required this.icon,
    required this.filter,
  });
}