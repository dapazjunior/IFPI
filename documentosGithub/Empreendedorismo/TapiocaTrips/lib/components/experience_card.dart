import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/experience.dart';

/// Card de experiência para listagem principal
class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onTap;
  
  const ExperienceCard({
    super.key,
    required this.experience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com categoria e XP
              Row(
                children: [
                  // Categoria
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          experience.categoryIcon,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          experience.category,
                          style: TextStyle(
                            color: _getCategoryColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // XP
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.culturalOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: AppTheme.culturalOrange,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '+${experience.xpReward} XP',
                          style: TextStyle(
                            color: AppTheme.culturalOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Título
              Text(
                experience.title,
                style: TextStyle(
                  color: AppTheme.sustainableGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Descrição
              Text(
                experience.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Rodapé com informações
              Row(
                children: [
                  // Localização
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        experience.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Dificuldade
                  Row(
                    children: [
                      Icon(
                        Icons.landscape,
                        size: 14,
                        color: _getDifficultyColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        experience.difficulty,
                        style: TextStyle(
                          color: _getDifficultyColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Duração
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(experience.estimatedDuration),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Progresso (se houver)
              if (experience.progress > 0) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: experience.progress,
                  backgroundColor: Colors.grey.shade200,
                  color: AppTheme.sustainableGreen,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 4),
                Text(
                  '${experience.completedStepsCount}/${experience.steps.length} etapas',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Retorna cor baseada na categoria
  Color _getCategoryColor() {
    switch (experience.category) {
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

  /// Retorna cor baseada na dificuldade
  Color _getDifficultyColor() {
    switch (experience.difficulty) {
      case 'Fácil':
        return Colors.green;
      case 'Moderado':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formata duração para exibição
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}min';
    }
  }
}