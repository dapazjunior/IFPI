import 'package:flutter/material.dart';
import '../services/gamification_service.dart';
import '../models/badge_model.dart';
import '../components/level_progress_bar.dart';
import '../components/badge_card.dart';
import '../utils/theme.dart';

/// Tela do Passaporte Verde - Mostra progresso, conquistas e estatísticas do usuário
class PassportScreen extends StatefulWidget {
  const PassportScreen({super.key});

  @override
  State<PassportScreen> createState() => _PassportScreenState();
}

class _PassportScreenState extends State<PassportScreen> {
  UserStats? _userStats;
  List<Badge> _allBadges = [];
  List<String> _recentActivities = [];
  bool _isLoading = true;
  BadgeType _selectedFilter = BadgeType.exploration;

  @override
  void initState() {
    super.initState();
    _loadGamificationData();
  }

  /// Carrega todos os dados de gamificação
  Future<void> _loadGamificationData() async {
    await GamificationService.initialize();
    
    if (mounted) {
      setState(() {
        _userStats = GamificationService.currentStats;
        _allBadges = GamificationService.allBadges;
        _recentActivities = GamificationService.recentActivities;
        _isLoading = false;
      });
    }
  }

  /// Constrói o cabeçalho com estatísticas resumidas
  Widget _buildHeaderStats() {
    if (_userStats == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sustainableGreen.withOpacity(0.9),
            AppTheme.sustainableGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Título
          const Text(
            '🛂 Passaporte Verde Tapioca',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sua jornada sustentável pelo Piauí',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          
          // Estatísticas em grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('${_userStats!.routesCompleted}', 'Rotas', Icons.explore_rounded),
              _buildStatItem('${_userStats!.reviewsWritten}', 'Avaliações', Icons.reviews_rounded),
              _buildStatItem('${_userStats!.sharesDone}', 'Compart.', Icons.share_rounded),
              _buildStatItem('${_userStats!.badgesUnlocked}', 'Conquistas', Icons.emoji_events_rounded),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói item de estatística
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de nível e progresso
  Widget _buildLevelSection() {
    if (_userStats == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LevelProgressBar(
        userStats: _userStats!,
        showDetails: true,
      ),
    );
  }

  /// Constrói os filtros de tipos de badges
  Widget _buildBadgeFilters() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('🌿 Exploração', BadgeType.exploration),
          _buildFilterChip('💬 Social', BadgeType.social),
          _buildFilterChip('✅ Conclusão', BadgeType.completion),
          _buildFilterChip('📤 Compart.', BadgeType.sharing),
          _buildFilterChip('⭐ Especiais', BadgeType.special),
        ],
      ),
    );
  }

  /// Constrói chip de filtro
  Widget _buildFilterChip(String label, BadgeType type) {
    final isSelected = _selectedFilter == type;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = type;
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: AppTheme.sustainableGreen.withOpacity(0.2),
        checkmarkColor: AppTheme.sustainableGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.sustainableGreen : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  /// Constrói a grid de badges
  Widget _buildBadgesGrid() {
    final filteredBadges = _allBadges.where((badge) => badge.type == _selectedFilter).toList();
    
    if (filteredBadges.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: filteredBadges.length,
        itemBuilder: (context, index) {
          final badge = filteredBadges[index];
          return BadgeCard(
            badge: badge,
            isCompact: true,
            onTap: () => _showBadgeDetails(badge),
          );
        },
      ),
    );
  }

  /// Constrói estado vazio
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma conquista deste tipo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Continue explorando para desbloquear mais conquistas!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Constrói a seção de atividades recentes
  Widget _buildRecentActivities() {
    if (_recentActivities.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 Atividades Recentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _recentActivities.take(5).map((activity) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.fiber_manual_record_rounded, 
                            size: 8, color: AppTheme.culturalOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            activity,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra detalhes de uma badge
  void _showBadgeDetails(Badge badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(badge.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                badge.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            if (!badge.unlocked) ...[
              LinearProgressIndicator(
                value: badge.progress,
                backgroundColor: Colors.grey[300],
                color: AppTheme.sustainableGreen,
              ),
              const SizedBox(height: 8),
              Text(
                'Progresso: ${badge.currentValue}/${badge.targetValue}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.sustainableGreen,
                ),
              ),
            ] else if (badge.unlockDate != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Desbloqueada em ${_formatDate(badge.unlockDate!)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /// Formata data para exibição
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Passaporte Verde'),
        backgroundColor: AppTheme.sustainableGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadGamificationData,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadGamificationData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Cabeçalho com estatísticas
                    _buildHeaderStats(),
                    
                    // Seção de nível
                    _buildLevelSection(),
                    
                    // Filtros de badges
                    _buildBadgeFilters(),
                    
                    // Grid de badges
                    _buildBadgesGrid(),
                    
                    // Atividades recentes
                    _buildRecentActivities(),
                    
                    const SizedBox(height: 32),
                    
                    // Mensagem motivacional
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.culturalOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.culturalOrange.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '🌟 Continue sua jornada!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.culturalOrange,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Cada rota explorada, cada avaliação escrita e cada compartilhamento '
                            'te aproxima de novas conquistas e ajuda a promover o turismo sustentável no Piauí!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}