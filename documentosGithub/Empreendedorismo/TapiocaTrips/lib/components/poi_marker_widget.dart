import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';

/// Widget personalizado para marcadores no mapa
/// Exibe ícone e categoria com animações de seleção
class POIMarkerWidget extends StatefulWidget {
  final POI poi;
  final bool isSelected;
  
  const POIMarkerWidget({
    super.key,
    required this.poi,
    required this.isSelected,
  });

  @override
  State<POIMarkerWidget> createState() => _POIMarkerWidgetState();
}

class _POIMarkerWidgetState extends State<POIMarkerWidget> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant POIMarkerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Marcador principal
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: widget.isSelected 
                      ? _getCategoryColor(widget.poi.category) 
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                _getCategoryIcon(widget.poi.category),
                color: _getCategoryColor(widget.poi.category),
                size: 20,
              ),
            ),
            
            // Seta do marcador
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 24,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            
            // Label do marcador (apenas quando selecionado)
            if (widget.isSelected) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  widget.poi.name,
                  style: TextStyle(
                    color: _getCategoryColor(widget.poi.category),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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