import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/gamification_service.dart';

/// Botão de compartilhamento reutilizável para rotas
/// Permite compartilhar informações da rota via WhatsApp, Instagram, etc.
/// Integrado com o sistema de gamificação para conceder XP
class ShareButton extends StatelessWidget {
  final String routeTitle;
  final String routeDescription;
  final String? routeUrl;
  final Color? iconColor;
  final String routeId;

  const ShareButton({
    super.key,
    required this.routeTitle,
    required this.routeDescription,
    required this.routeId,
    this.routeUrl,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share_rounded, color: iconColor),
      tooltip: 'Compartilhar Rota',
      onPressed: () => _shareRoute(context),
    );
  }

  /// Compartilha as informações da rota e registra no sistema de gamificação
  void _shareRoute(BuildContext context) async {
    try {
      // Texto formatado para compartilhamento
      final text = '''
🗺️ *${routeTitle}*

${routeDescription}

🌿 *Explore essa rota incrível no Tapioca Trips!*

📍 *Características:*
• Rota autoguiada com narrações locais
• Funciona offline
• Turismo sustentável no Piauí
• Histórias contadas por moradores locais

${routeUrl ?? "📱 Baixe o Tapioca Trips para descobrir mais rotas!"}

#TapiocaTrips #TurismoSustentável #Piauí #${_generateHashtags(routeTitle)}
''';

      // Compartilha usando o share_plus
      final result = await Share.share(
        text,
        subject: 'Conheça a rota $routeTitle no Tapioca Trips',
      ).then((value) {
        // Quando o compartilhamento é concluído (ou cancelado)
        return value;
      });

      // Registra o compartilhamento no sistema de gamificação
      // Independente do resultado (usuário pode ter cancelado, mas a intenção foi registrada)
      await _registerShareInGamification();

      // Feedback visual opcional
      if (context.mounted) {
        _showShareConfirmation(context);
      }

    } catch (e) {
      // Em caso de erro no compartilhamento, ainda tenta registrar a tentativa
      await _registerShareInGamification();
      
      if (context.mounted) {
        _showShareError(context, e);
      }
    }
  }

  /// Registra o compartilhamento no sistema de gamificação
  Future<void> _registerShareInGamification() async {
    try {
      await GamificationService.shareRoute();
      
      // Log para debug (remover em produção)
      debugPrint('✅ Compartilhamento registrado: $routeTitle');
    } catch (e) {
      debugPrint('❌ Erro ao registrar compartilhamento: $e');
      // Não propaga o erro para não afetar a experiência do usuário
    }
  }

  /// Mostra confirmação de compartilhamento bem-sucedido
  void _showShareConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.share_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rota compartilhada!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '+10 XP ganhos no Passaporte Verde',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ver XP',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Navegar para a tela do Passaporte Verde
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _showXpDetails(context);
          },
        ),
      ),
    );
  }

  /// Mostra detalhes do XP ganho
  void _showXpDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('XP Ganho!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Você ganhou 10 XP por compartilhar esta rota!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_rounded, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    '+10 XP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Continue compartilhando para desbloquear a conquista "Influencer Tapioca"!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navegar para a tela do Passaporte Verde
              _navigateToPassport(context);
            },
            child: const Text('Ver Passaporte'),
          ),
        ],
      ),
    );
  }

  /// Navega para a tela do Passaporte Verde
  void _navigateToPassport(BuildContext context) {
    // TODO: Implementar navegação para PassportScreen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PassportScreen()));
    
    // Placeholder - mostra um snackbar informativo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passaporte Verde em breve disponível!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Mostra erro no compartilhamento
  void _showShareError(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Erro ao compartilhar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mas ainda ganhou +10 XP pela tentativa!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Gera hashtags baseadas no título da rota
  String _generateHashtags(String title) {
    // Remove acentos e caracteres especiais
    final cleanedTitle = title
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(' ', '');

    return cleanedTitle;
  }
}

/// Versão extendida do ShareButton com mais opções de personalização
class ExtendedShareButton extends StatelessWidget {
  final String routeTitle;
  final String routeDescription;
  final String routeId;
  final String? routeUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final String buttonText;
  final bool showXPFeedback;

  const ExtendedShareButton({
    super.key,
    required this.routeTitle,
    required this.routeDescription,
    required this.routeId,
    this.routeUrl,
    this.backgroundColor,
    this.textColor,
    this.icon = Icons.share_rounded,
    this.buttonText = 'Compartilhar Rota',
    this.showXPFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _shareRoute(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      icon: Icon(icon, size: 20),
      label: Text(buttonText),
    );
  }

  /// Compartilha a rota (mesma lógica do ShareButton básico)
  void _shareRoute(BuildContext context) async {
    try {
      final text = '''
🗺️ *${routeTitle}*

${routeDescription}

🌿 *Explore essa rota incrível no Tapioca Trips!*

📍 *Características:*
• Rota autoguiada com narrações locais
• Funciona offline
• Turismo sustentável no Piauí
• Histórias contadas por moradores locais

${routeUrl ?? "📱 Baixe o Tapioca Trips para descobrir mais rotas!"}

#TapiocaTrips #TurismoSustentável #Piauí #${_generateHashtags(routeTitle)}
''';

      await Share.share(
        text,
        subject: 'Conheça a rota $routeTitle no Tapioca Trips',
      );

      await _registerShareInGamification();

      if (showXPFeedback && context.mounted) {
        _showShareConfirmation(context);
      }

    } catch (e) {
      await _registerShareInGamification();
      
      if (showXPFeedback && context.mounted) {
        _showShareError(context, e);
      }
    }
  }

  /// Registra no sistema de gamificação
  Future<void> _registerShareInGamification() async {
    try {
      await GamificationService.shareRoute();
    } catch (e) {
      debugPrint('❌ Erro ao registrar compartilhamento: $e');
    }
  }

  /// Mostra confirmação
  void _showShareConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ $buttonText - +10 XP ganhos!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mostra erro
  void _showShareError(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('⚠️ Erro ao compartilhar, mas +10 XP ganhos!'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Gera hashtags
  String _generateHashtags(String title) {
    final cleanedTitle = title
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(' ', '');

    return cleanedTitle;
  }
}