import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../utils/theme.dart';

/// Card para exibir uma conquista (badge) - tanto desbloqueada quanto bloqueada
class BadgeCard extends StatelessWidget {
  final Badge badge;
  final VoidCallback? onTap;
  final bool isCompact;

  const BadgeCard({
    super.key,
    required this.badge,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: badge.unlocked ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: badge.unlocked 
          ? _getBadgeColor(badge.type).withOpacity(0.1)
          : Colors.grey[100],
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: isCompact ? _buildCompactView() : _buildDetailedView(),
      ),
    );
  }

  /// Visualização compacta (para grids)
  Widget _buildCompactView() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone/Emoji da badge
          Text(
            badge.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          // Título
          Text(
            badge.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: badge.unlocked ? Colors.black87 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Indicador de desbloqueio
          if (badge.unlocked) ...[
            const SizedBox(height: 4),
            Icon(
              Icons.verified_rounded,
              color: _getBadgeColor(badge.type),
              size: 12,
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              '${badge.currentValue}/${badge.targetValue}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Visualização detalhada (para lista)
  Widget _buildDetailedView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Ícone/Emoji
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: badge.unlocked 
                  ? _getBadgeColor(badge.type).withOpacity(0.2)
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                badge.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Informações da badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: badge.unlocked ? Colors.black87 : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: TextStyle(
                    color: badge.unlocked ? Colors.grey[700] : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Barra de progresso
                if (!badge.unlocked) ...[
                  LinearProgressIndicator(
                    value: badge.progress,
                    backgroundColor: Colors.grey[300],
                    color: _getBadgeColor(badge.type),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Progresso: ${badge.currentValue}/${badge.targetValue}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ] else if (badge.unlockDate != null) ...[
                  Text(
                    'Desbloqueada em ${_formatDate(badge.unlockDate!)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Indicador de status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badge.unlocked 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: badge.unlocked ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Text(
              badge.unlocked ? '🏆 Conquistada' : '🔒 Em progresso',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badge.unlocked ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna a cor baseada no tipo da badge
  Color _getBadgeColor(BadgeType type) {
    switch (type) {
      case BadgeType.exploration:
        return AppTheme.sustainableGreen;
      case BadgeType.social:
        return Colors.blue;
      case BadgeType.completion:
        return Colors.purple;
      case BadgeType.sharing:
        return Colors.orange;
      case BadgeType.special:
        return Colors.red;
      default:
        return AppTheme.culturalOrange;
    }
  }

  /// Formata a data para exibição
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}