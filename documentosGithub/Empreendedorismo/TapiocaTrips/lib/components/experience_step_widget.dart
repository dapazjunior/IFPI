import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/experience.dart';

/// Widget de etapa individual da experiência
class ExperienceStepWidget extends StatelessWidget {
  final ExperienceStep step;
  final int stepNumber;
  final VoidCallback onToggle;
  
  const ExperienceStepWidget({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: _buildStepIndicator(),
        title: Text(
          step.title,
          style: TextStyle(
            color: AppTheme.sustainableGreen,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: step.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: step.description.isNotEmpty
            ? Text(
                step.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  decoration: step.isCompleted ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        trailing: Icon(
          step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: step.isCompleted ? AppTheme.sustainableGreen : Colors.grey.shade400,
        ),
        onTap: onToggle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// Indicador visual da etapa (número ou ícone)
  Widget _buildStepIndicator() {
    if (step.isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.sustainableGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            stepNumber.toString(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}