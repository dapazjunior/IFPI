import 'package:flutter/material.dart';
import 'routes_list_screen.dart';
import 'about_screen.dart';
import 'passport_screen.dart'; // NOVO IMPORT
import '../utils/constants.dart';
import '../utils/theme.dart';

/// Home Screen - Main landing page showcasing Piauí's cultural identity
/// Features gradient background inspired by Piauí landscapes and easy navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Gradient background inspired by Piauí landscapes
        // Represents the Delta do Parnaíba (blue) and Serra da Capivara (orange/brown)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B5E20), // Dark green - forests
              Color(0xFF2E7D32), // Medium green - vegetation
              Color(0xFF4CAF50), // Light green - fields
              Color(0xFFFF9800), // Orange - sunset & earth tones
              Color(0xFFF57C00), // Dark orange - Serra da Capivara
            ],
            stops: [0.0, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section with app identity
              _buildHeaderSection(screenHeight, context),
              
              // Main content with buttons
              Expanded(
                child: _buildContentSection(context, screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header section with app logo, title, and subtitle
  Widget _buildHeaderSection(double screenHeight, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          // App Logo/Icon with cultural inspiration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.explore,
              size: 60,
              color: AppTheme.sustainableGreen,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Title with shadow for better readability
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFFFEB3B)],
            ).createShader(bounds),
            child: Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Cultural subtitle
          Text(
            'Sabores, histórias e caminhos do Piauí',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the main content section with welcome text and navigation buttons
  Widget _buildContentSection(BuildContext context, double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              // Welcome message
              _buildWelcomeMessage(context),
              
              const SizedBox(height: 40),
              
              // Main navigation buttons
              _buildNavigationButtons(context, screenWidth),
              
              const SizedBox(height: 30),
              
              // Cultural heritage note
              _buildCulturalNote(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the welcome message section
  Widget _buildWelcomeMessage(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.emoji_people,
          size: 50,
          color: AppTheme.culturalOrange,
        ),
        const SizedBox(height: 16),
        Text(
          'Bem-vindo!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.sustainableGreen,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Descubra as rotas autoguiadas que conectam você com a cultura, '
          'histórias locais e paisagens impressionantes do Piauí. '
          'Ouça as vozes dos moradores e explore de forma sustentável.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the main navigation buttons with cultural-inspired design
  Widget _buildNavigationButtons(BuildContext context, double screenWidth) {
    return Column(
      children: [
        // Explore Routes Button - Primary action
        _buildCulturalButton(
          context: context,
          icon: Icons.map_rounded,
          title: 'Explorar Rotas',
          subtitle: 'Descubra percursos e histórias',
          color: AppTheme.sustainableGreen,
          onTap: () => _navigateWithAnimation(context, const RoutesListScreen()),
        ),
        
        const SizedBox(height: 20),
        
        // Download Offline Button - Secondary action
        _buildCulturalButton(
          context: context,
          icon: Icons.download_rounded,
          title: 'Baixar para Offline',
          subtitle: 'Explore sem conexão',
          color: AppTheme.culturalOrange,
          onTap: () => _showOfflinePlaceholder(context),
        ),
        
        const SizedBox(height: 20),

        // NOVO BOTÃO: Passaporte Verde
        _buildCulturalButton(
          context: context,
          icon: Icons.emoji_events_rounded,
          title: 'Meu Passaporte Verde',
          subtitle: 'Conquistas e progresso',
          color: const Color(0xFF4CAF50),
          onTap: () => _navigateWithAnimation(context, const PassportScreen()),
        ),
        
        const SizedBox(height: 20),
        
        // About Project Button - Tertiary action
        _buildCulturalButton(
          context: context,
          icon: Icons.info_outline_rounded,
          title: 'Sobre o Projeto',
          subtitle: 'Conheça nossa missão',
          color: const Color(0xFF2196F3),
          onTap: () => _navigateWithAnimation(context, const AboutScreen()),
        ),
      ],
    );
  }

  /// Builds a custom cultural-inspired button with icon and text
  Widget _buildCulturalButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.9),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Chevron indicator
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds cultural heritage note at the bottom
  Widget _buildCulturalNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.eco_rounded,
            color: AppTheme.sustainableGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Turismo sustentável que valoriza a cultura local e preserva o patrimônio natural do Piauí',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to a screen with a custom slide animation
  void _navigateWithAnimation(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  /// Shows placeholder for offline download functionality
  void _showOfflinePlaceholder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Offline'),
        content: const Text('Esta funcionalidade estará disponível em breve! '
            'Você poderá baixar rotas completas com mapas e áudios para explorar sem conexão.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}