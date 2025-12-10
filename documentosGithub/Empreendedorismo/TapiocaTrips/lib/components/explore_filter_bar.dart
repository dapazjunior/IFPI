import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';

/// Barra de filtros para explorar categorias de POIs
/// Permite filtrar por Cultural, Natureza, Gastronomia, Sustentável
class ExploreFilterBar extends StatefulWidget {
  final Function(Set<String>) onFiltersChanged;
  final Set<String> activeFilters;
  
  const ExploreFilterBar({
    super.key,
    required this.onFiltersChanged,
    required this.activeFilters,
  });

  @override
  State<ExploreFilterBar> createState() => _ExploreFilterBarState();
}

class _ExploreFilterBarState extends State<ExploreFilterBar> {
  // Categorias disponíveis
  final List<FilterCategory> _categories = [
    FilterCategory(
      name: 'Cultural',
      icon: Icons.account_balance,
      color: AppTheme.culturalOrange,
    ),
    FilterCategory(
      name: 'Natureza',
      icon: Icons.eco,
      color: Colors.green,
    ),
    FilterCategory(
      name: 'Gastronomia',
      icon: Icons.restaurant,
      color: Colors.red,
    ),
    FilterCategory(
      name: 'Sustentável',
      icon: Icons.leaf,
      color: AppTheme.sustainableGreen,
    ),
  ];

  /// Alterna filtro de categoria
  void _toggleFilter(String category) {
    final newFilters = Set<String>.from(widget.activeFilters);
    
    if (newFilters.contains(category)) {
      newFilters.remove(category);
    } else {
      newFilters.add(category);
    }
    
    widget.onFiltersChanged(newFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e contador
          Row(
            children: [
              Icon(
                Icons.explore,
                color: AppTheme.sustainableGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Explorar Tapioca 🌎',
                style: TextStyle(
                  color: AppTheme.sustainableGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (widget.activeFilters.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.culturalOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.activeFilters.length} ativo(s)',
                    style: TextStyle(
                      color: AppTheme.culturalOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Filtros de categoria
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isActive = widget.activeFilters.contains(category.name);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.name),
                    avatar: Icon(
                      category.icon,
                      size: 16,
                      color: isActive ? Colors.white : category.color,
                    ),
                    selected: isActive,
                    onSelected: (_) => _toggleFilter(category.name),
                    backgroundColor: Colors.white,
                    selectedColor: category.color,
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isActive ? category.color : Colors.grey.shade300,
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
    );
  }
}

/// Modelo de categoria de filtro
class FilterCategory {
  final String name;
  final IconData icon;
  final Color color;

  FilterCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}