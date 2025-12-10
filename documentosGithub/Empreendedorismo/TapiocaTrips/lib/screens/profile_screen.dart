import 'package:flutter/material.dart';
import 'package:tapioca_trips/theme/app_theme.dart';
import 'package:tapioca_trips/models/user_progress.dart';
import 'package:tapioca_trips/components/profile_stats_card.dart';
import 'package:tapioca_trips/components/achievement_badge_widget.dart';

/// Tela de perfil do viajante - Exibe progresso, estatísticas e conquistas
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
    with SingleTickerProviderStateMixin {
  
  // Dados do usuário (mock)
  late UserProgress _userProgress;
  
  // Controlador de animação
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Estado de carregamento
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Configura animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Simula carregamento dos dados
    _loadUserData();
  }

  /// Carrega dados do usuário (mock)
  void _loadUserData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _userProgress = UserProgress.mock();
      _isLoading = false;
    });
    
    // Inicia animação após carregamento
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? _buildLoadingState()
          : _buildProfileContent(),
    );
  }

  /// Conteúdo principal do perfil
  Widget _buildProfileContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          // AppBar personalizada
          _buildProfileAppBar(),
          
          // Conteúdo do perfil
          SliverList(
            delegate: SliverChildListDelegate([
              // Cabeçalho do perfil
              _buildProfileHeader(),
              
              // Barra de progresso do nível
              _buildLevelProgressCard(),
              
              // Estatísticas do viajante
              _buildStatsSection(),
              
              // Conquistas e medalhas
              _buildAchievementsSection(),
              
              // Ações do perfil
              _buildProfileActions(),
              
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  /// AppBar personalizada do perfil
  SliverAppBar _buildProfileAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      title: Text(
        'Meu Perfil',
        style: TextStyle(
          color: AppTheme.sustainableGreen,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showSettings,
          icon: Icon(
            Icons.settings_outlined,
            color: AppTheme.sustainableGreen,
          ),
        ),
      ],
    );
  }

  /// Cabeçalho com avatar e informações básicas
  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar e nível
          Stack(
            alignment: Alignment.center,
            children: [
              // Avatar do usuário
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.culturalOrange.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: _userProgress.avatarUrl != null
                      ? Image.asset(
                          _userProgress.avatarUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.sustainableGreen.withOpacity(0.3),
                                AppTheme.culturalOrange.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppTheme.sustainableGreen,
                          ),
                        ),
                ),
              ),
              
              // Badge de nível
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.culturalOrange,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Nv. ${_userProgress.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Nome do usuário
          Text(
            _userProgress.name,
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Saudação personalizada
          Text(
            _getGreeting(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Data de ingresso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                'Membro desde ${_formatDate(_userProgress.memberSince)}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card de progresso do nível e XP
  Widget _buildLevelProgressCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do progresso
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppTheme.culturalOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Progresso do Viajante',
                style: TextStyle(
                  color: AppTheme.sustainableGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progresso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Labels de XP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_userProgress.currentXP} XP',
                    style: TextStyle(
                      color: AppTheme.sustainableGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_userProgress.xpToNextLevel} XP',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Barra de progresso
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [
                    // Progresso
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      height: 12,
                      width: MediaQuery.of(context).size.width * 
                            _userProgress.progressPercentage * 0.7,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.sustainableGreen,
                            AppTheme.culturalOrange,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Informação do próximo nível
              Text(
                '${_userProgress.xpRemaining} XP para o nível ${_userProgress.level + 1}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Seção de estatísticas do viajante
  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              'Minhas Estatísticas',
              style: TextStyle(
                color: AppTheme.sustainableGreen,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              ProfileStatsCard(
                icon: Icons.place,
                value: _userProgress.placesVisited.toString(),
                label: 'Locais Visitados',
                color: AppTheme.sustainableGreen,
              ),
              ProfileStatsCard(
                icon: Icons.flag,
                value: _userProgress.experiencesCompleted.toString(),
                label: 'Experiências',
                color: AppTheme.culturalOrange,
              ),
              ProfileStatsCard(
                icon: Icons.auto_awesome,
                value: _userProgress.totalXP.toString(),
                label: 'XP Total',
                color: Colors.green,
              ),
              ProfileStatsCard(
                icon: Icons.celebration,
                value: _userProgress.achievements.length.toString(),
                label: 'Conquistas',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Seção de conquistas e medalhas
  Widget _buildAchievementsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Row(
              children: [
                Text(
                  'Minhas Conquistas',
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
                    _userProgress.achievements.length.toString(),
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
          
          _userProgress.achievements.isNotEmpty
              ? _buildAchievementsList()
              : _buildEmptyAchievements(),
        ],
      ),
    );
  }

  /// Lista horizontal de conquistas
  Widget _buildAchievementsList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _userProgress.achievements.length,
        itemBuilder: (context, index) {
          final achievement = _userProgress.achievements[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 8 : 0,
              right: 8,
            ),
            child: AchievementBadgeWidget(
              achievement: achievement,
              onTap: () => _showAchievementDetails(achievement),
            ),
          );
        },
      ),
    );
  }

  /// Estado vazio para conquistas
  Widget _buildEmptyAchievements() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhuma conquista ainda',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore novos locais para desbloquear conquistas!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Ações do perfil (botões)
  Widget _buildProfileActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileActionButton(
            icon: Icons.edit,
            label: 'Editar Perfil',
            onTap: _editProfile,
          ),
          const Divider(height: 24),
          _buildProfileActionButton(
            icon: Icons.history,
            label: 'Histórico de Viagens',
            onTap: _showTravelHistory,
          ),
          const Divider(height: 24),
          _buildProfileActionButton(
            icon: Icons.share,
            label: 'Compartilhar Perfil',
            onTap: _shareProfile,
          ),
        ],
      ),
    );
  }

  /// Botão de ação do perfil
  Widget _buildProfileActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.sustainableGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.sustainableGreen,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: AppTheme.sustainableGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
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
            'Carregando seu perfil...',
            style: TextStyle(
              color: AppTheme.sustainableGreen,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna saudação baseada no horário
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia, explorador! 🌅';
    if (hour < 18) return 'Boa tarde, aventureiro! ☀️';
    return 'Boa noite, viajante! 🌙';
  }

  /// Formata data para exibição
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Métodos de ações (placeholders)
  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '⚙️ Configurações - Em breve!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.sustainableGreen,
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✏️ Editar Perfil - Em breve!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.culturalOrange,
      ),
    );
  }

  void _showTravelHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '📅 Histórico de Viagens - Em breve!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '📤 Compartilhar Perfil - Em breve!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(achievement.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(achievement.name),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 8),
            Text(
              '🎯 +${achievement.xpReward} XP',
              style: TextStyle(
                color: AppTheme.culturalOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Desbloqueado em ${_formatDate(achievement.unlockedAt)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(color: AppTheme.sustainableGreen),
            ),
          ),
        ],
      ),
    );
  }
}