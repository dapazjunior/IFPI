import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/user_progress.dart';

/// Widget de badge de conquista com animações e interações
class AchievementBadgeWidget extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onTap;
  
  const AchievementBadgeWidget({
    super.key,
    required this.achievement,
    required this.onTap,
  });

  @override
  State<AchievementBadgeWidget> createState() => _AchievementBadgeWidgetState();
}

class _AchievementBadgeWidgetState extends State<AchievementBadgeWidget> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 120,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: _getCategoryColor().withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji/Ícone da conquista
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.achievement.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Nome da conquista
                  Text(
                    widget.achievement.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.sustainableGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // XP da conquista
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.culturalOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${widget.achievement.xpReward} XP',
                      style: TextStyle(
                        color: AppTheme.culturalOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Retorna cor baseada na categoria da conquista
  Color _getCategoryColor() {
    switch (widget.achievement.category) {
      case 'Cultural':
        return AppTheme.culturalOrange;
      case 'Natureza':
        return Colors.green;
      case 'Gastronomia':
        return Colors.red;
      case 'Sustentável':
        return AppTheme.sustainableGreen;
      default:
        return Colors.blue;
    }
  }
}