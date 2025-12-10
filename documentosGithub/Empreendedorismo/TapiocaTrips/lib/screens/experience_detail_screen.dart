import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/experience.dart';
import 'package:tapioca_trips/components/experience_step_widget.dart';

/// Tela detalhada de uma experiência interativa
class ExperienceDetailScreen extends StatefulWidget {
  final Experience experience;
  
  const ExperienceDetailScreen({
    super.key,
    required this.experience,
  });

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  late Experience _experience;
  bool _showCompletionAnimation = false;

  @override
  void initState() {
    super.initState();
    _experience = widget.experience;
  }

  /// Alterna estado de conclusão de uma etapa
  void _toggleStepCompletion(int stepIndex) {
    setState(() {
      final updatedSteps = List<ExperienceStep>.from(_experience.steps);
      updatedSteps[stepIndex] = updatedSteps[stepIndex].copyWith(
        isCompleted: !updatedSteps[stepIndex].isCompleted,
      );
      
      _experience = Experience(
        id: _experience.id,
        title: _experience.title,
        category: _experience.category,
        location: _experience.location,
        description: _experience.description,
        detailedDescription: _experience.detailedDescription,
        xpReward: _experience.xpReward,
        imageUrl: _experience.imageUrl,
        steps: updatedSteps,
        estimatedDuration: _experience.estimatedDuration,
        difficulty: _experience.difficulty,
        isFeatured: _experience.isFeatured,
        rating: _experience.rating,
        completionsCount: _experience.completionsCount,
        tags: _experience.tags,
      );
    });

    // Verifica se todas as etapas foram concluídas
    if (_experience.isComplete && !_showCompletionAnimation) {
      _showCompletionReward();
    }
  }

  /// Mostra recompensa por conclusão da experiência
  void _showCompletionReward() {
    setState(() {
      _showCompletionAnimation = true;
    });

    // Mostra feedback de conclusão
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.sustainableGreen,
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "🎉 Experiência Concluída! +${_experience.xpReward} XP",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Reseta animação após delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCompletionAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar com imagem
          _buildExperienceAppBar(),
          
          // Conteúdo da experiência
          SliverList(
            delegate: SliverChildListDelegate([
              // Informações principais
              _buildExperienceInfo(),
              
              // Descrição detalhada
              _buildDetailedDescription(),
              
              // Etapas da experiência
              _buildExperienceSteps(),
              
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
      
      // Botão de ação flutuante
      floatingActionButton: _experience.isComplete
          ? _buildCompletionFab()
          : _buildProgressFab(),
    );
  }

  /// AppBar com imagem da experiência
  SliverAppBar _buildExperienceAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getCategoryColor().withOpacity(0.3),
                _getCategoryColor().withOpacity(0.1),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Ícone central representativo
              Center(
                child: Text(
                  _experience.categoryIcon,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              
              // Overlay de gradiente
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Informações principais da experiência
  Widget _buildExperienceInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com título e categoria
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categoria
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _experience.categoryIcon,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _experience.category,
                            style: TextStyle(
                              color: _getCategoryColor(),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Título
                    Text(
                      _experience.title,
                      style: TextStyle(
                        color: AppTheme.sustainableGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Localização
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _experience.location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // XP Reward
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.culturalOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppTheme.culturalOrange,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${_experience.xpReward}',
                      style: TextStyle(
                        color: AppTheme.culturalOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'XP',
                      style: TextStyle(
                        color: AppTheme.culturalOrange,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Metadados
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildMetadataItem(
                Icons.schedule,
                _formatDuration(_experience.estimatedDuration),
              ),
              _buildMetadataItem(
                Icons.landscape,
                _experience.difficulty,
                color: _getDifficultyColor(),
              ),
              _buildMetadataItem(
                Icons.flag,
                '${_experience.completionsCount} concluíram',
              ),
              _buildMetadataItem(
                Icons.star,
                _experience.rating.toString(),
                color: AppTheme.culturalOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Item de metadado
  Widget _buildMetadataItem(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Descrição detalhada
  Widget _buildDetailedDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre esta experiência',
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            _experience.detailedDescription,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _experience.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Lista de etapas da experiência
  Widget _buildExperienceSteps() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Etapas da Experiência',
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progresso
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _experience.progress,
                  backgroundColor: Colors.grey.shade200,
                  color: AppTheme.sustainableGreen,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progresso',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${_experience.completedStepsCount}/${_experience.steps.length}',
                      style: TextStyle(
                        color: AppTheme.sustainableGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de etapas
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _experience.steps.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final step = _experience.steps[index];
              return ExperienceStepWidget(
                step: step,
                stepNumber: index + 1,
                onToggle: () => _toggleStepCompletion(index),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Botão de progresso (quando não está completo)
  Widget _buildProgressFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navega para a primeira etapa não concluída
        final firstIncomplete = _experience.steps.indexWhere((step) => !step.isCompleted);
        if (firstIncomplete != -1) {
          _toggleStepCompletion(firstIncomplete);
        }
      },
      backgroundColor: AppTheme.sustainableGreen,
      foregroundColor: Colors.white,
      icon: Icon(
        _experience.completedStepsCount > 0 ? Icons.play_arrow : Icons.play_circle_fill,
      ),
      label: Text(
        _experience.completedStepsCount > 0 ? 'Continuar' : 'Iniciar',
      ),
    );
  }

  /// Botão de conclusão (quando está completo)
  Widget _buildCompletionFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showCompletionReward();
      },
      backgroundColor: _showCompletionAnimation ? AppTheme.culturalOrange : AppTheme.sustainableGreen,
      foregroundColor: Colors.white,
      icon: _showCompletionAnimation
          ? const Icon(Icons.celebration)
          : const Icon(Icons.check_circle),
      label: _showCompletionAnimation
          ? const Text('Parabéns!')
          : const Text('Concluído'),
    );
  }

  /// Retorna cor baseada na categoria
  Color _getCategoryColor() {
    switch (_experience.category) {
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
    switch (_experience.difficulty) {
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
      return '${duration.inHours} hora${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minuto${duration.inMinutes > 1 ? 's' : ''}';
    }
  }
}