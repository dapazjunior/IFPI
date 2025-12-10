import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/route_model.dart';
import '../components/map_view.dart';
import '../components/audio_player.dart';
import '../components/share_button.dart';
import '../components/review_card.dart';
import '../services/offline_service.dart';
import '../services/user_service.dart';
import '../services/review_service.dart';
import '../services/gamification_service.dart'; // ← IMPORT ADICIONADO
import 'narratives_screen.dart'; // ← IMPORT ADICIONADO
import '../utils/theme.dart';

/// Tela de Detalhes da Rota - Exibe informações completas da rota turística
/// Inclui mapa interativo, lista de pontos de interesse, player de áudio, funcionalidade offline e sistema social
class RouteDetailScreen extends StatefulWidget {
  final TourismRoute route;

  const RouteDetailScreen({super.key, required this.route});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OfflineService _offlineService = OfflineService();
  final ScrollController _scrollController = ScrollController();
  
  int _selectedPoiIndex = 0;
  bool _isPlaying = false;
  String? _currentlyPlayingAudio;
  bool _isAvailableOffline = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _isFavorite = false;

  // NOVAS VARIÁVEIS PARA REVIEWS
  List<Map<String, dynamic>> _reviews = [];
  double _averageRating = 0.0;
  int _reviewCount = 0;
  bool _showReviewDialog = false;
  double _newRating = 5.0;
  String _newComment = '';
  bool _reviewsLoading = true;

  // Mock data para pontos de interesse - será substituído por dados reais
  List<PointOfInterest> get _pointsOfInterest {
    return widget.route.pointsOfInterest ?? _getMockPointsOfInterest();
  }

  List<PointOfInterest> _getMockPointsOfInterest() {
    return [
      PointOfInterest(
        id: '1',
        name: 'Porto das Barcas',
        description: 'Centro histórico com arquitetura do século XIX e comércio local tradicional. Ouça histórias dos antigos comerciantes.',
        latitude: -5.0892,
        longitude: -42.8016,
        audioStoryUrl: 'https://example.com/audio/porto_barcas.mp3',
        estimatedVisitTime: 30,
        category: 'Cultural',
        localTip: 'Visite no final da tarde para aproveitar o pôr do sol no rio',
      ),
      PointOfInterest(
        id: '2',
        name: 'Mirante do Rio Parnaíba',
        description: 'Vista panorâmica do encontro do rio com o mar. Narrativas de pescadores locais sobre a vida no delta.',
        latitude: -5.0915,
        longitude: -42.8031,
        audioStoryUrl: 'https://example.com/audio/mirante_parnaiba.mp3',
        estimatedVisitTime: 20,
        category: 'Natureza',
        localTip: 'Leve binóculos para observar as aves migratórias',
      ),
      PointOfInterest(
        id: '3',
        name: 'Mercado Público',
        description: 'Experimente sabores locais e ouça histórias dos vendedores sobre tradições culinárias do Piauí.',
        latitude: -5.0881,
        longitude: -42.7998,
        audioStoryUrl: 'https://example.com/audio/mercado_publico.mp3',
        estimatedVisitTime: 45,
        category: 'Gastronomia',
        localTip: 'Prove a tapioca com queijo coalho no café da manhã',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
    _checkOfflineAvailability();
    _initializeOfflineService();
    _checkIfFavorite();
    _addToRecentlyViewed();
    _loadReviews(); // ← NOVO: Carrega as avaliações
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Inicializa o serviço offline
  void _initializeOfflineService() async {
    await _offlineService.initialize();
  }

  /// Verifica se a rota está disponível offline
  void _checkOfflineAvailability() async {
    final isAvailable = await _offlineService.isRouteAvailableOffline(widget.route.id);
    if (mounted) {
      setState(() {
        _isAvailableOffline = isAvailable;
      });
    }
  }

  /// Verifica se a rota é favorita
  void _checkIfFavorite() async {
    final isFav = await UserService.isFavorite(widget.route.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  /// Adiciona a rota ao histórico de visualizações
  void _addToRecentlyViewed() async {
    await UserService.addRecentlyViewed(widget.route.id);
  }

  /// Inicializa o player de áudio
  void _initializeAudioPlayer() async {
    // Configura listeners para o player de áudio
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }

  /// Carrega as avaliações da rota
  void _loadReviews() async {
    if (mounted) {
      setState(() {
        _reviewsLoading = true;
      });
    }

    final reviews = await ReviewService.getReviews(widget.route.id);
    final stats = await ReviewService.getReviewStats(widget.route.id);
    
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _averageRating = stats['averageRating'];
        _reviewCount = stats['reviewCount'];
        _reviewsLoading = false;
      });
    }
  }

  /// Baixa a rota para uso offline
  void _downloadRouteForOffline() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final success = await _offlineService.downloadRoute(widget.route);
      
      if (success && mounted) {
        setState(() {
          _isAvailableOffline = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Rota baixada com sucesso! Agora você pode acessá-la offline.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao baixar rota: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });
      }
    }
  }

  /// Remove a rota do armazenamento offline
  void _removeOfflineRoute() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Rota Offline'),
        content: const Text('Tem certeza que deseja remover esta rota do armazenamento offline? Os áudios baixados serão excluídos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _offlineService.deleteOfflineRoute(widget.route.id);
      
      if (success && mounted) {
        setState(() {
          _isAvailableOffline = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Rota removida do armazenamento offline'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Alterna o estado de favorito
  void _toggleFavorite() async {
    await UserService.toggleFavorite(widget.route.id);
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      
      // Feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite 
                ? '❤️ Rota adicionada aos favoritos!'
                : '💔 Rota removida dos favoritos',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Mostra diálogo de confirmação para download offline
  void _showDownloadConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download_rounded, color: Colors.blue),
            SizedBox(width: 12),
            Text('Baixar para Offline'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deseja baixar esta rota para uso offline?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 O que será baixado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('• Informações da rota'),
                  Text('• Pontos de interesse'),
                  Text('• Áudios das histórias locais'),
                  Text('• Mapas (em breve)'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você poderá acessar esta rota mesmo sem internet!',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadRouteForOffline();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Baixar Rota'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para adicionar avaliação
  void _showAddReviewDialog() {
    setState(() {
      _showReviewDialog = true;
      _newRating = 5.0;
      _newComment = '';
    });

    showDialog(
      context: context,
      builder: (context) => _buildReviewDialog(),
    ).then((_) {
      setState(() {
        _showReviewDialog = false;
      });
    });
  }

  /// Constrói o diálogo de avaliação
  Widget _buildReviewDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.reviews_rounded, color: AppTheme.culturalOrange),
              SizedBox(width: 8),
              Text('Avaliar Rota'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.route.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.sustainableGreen,
                  ),
                ),
                const SizedBox(height: 16),
                // Avaliação com estrelas
                const Text(
                  'Como foi sua experiência nesta rota?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _newRating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 36,
                      ),
                      onPressed: () {
                        setState(() {
                          _newRating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                Center(
                  child: Text(
                    '${_newRating.toInt()} ${_newRating.toInt() == 1 ? 'estrela' : 'estrelas'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de comentário
                const Text(
                  'Compartilhe sua experiência (opcional):',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Seu comentário',
                    border: OutlineInputBorder(),
                    hintText: 'Conte como foi explorar esta rota...',
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      _newComment = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _newComment.isEmpty ? 'Digite um comentário para enviar' : '${_newComment.length}/500 caracteres',
                  style: TextStyle(
                    fontSize: 12,
                    color: _newComment.isEmpty ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _newComment.trim().isEmpty ? null : () => _submitReview(setState),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sustainableGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar Avaliação'),
            ),
          ],
        );
      },
    );
  }

  /// Submete a avaliação
  void _submitReview(void Function(void Function()) setState) async {
    final userName = await ReviewService.getCurrentUserName();
    
    try {
      await ReviewService.addReview(
        routeId: widget.route.id,
        user: userName,
        comment: _newComment.trim(),
        rating: _newRating,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Avaliação enviada com sucesso!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        await _loadReviews(); // Recarrega as avaliações
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao enviar avaliação: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Toca o áudio de um ponto de interesse específico
  void _playPoiAudio(PointOfInterest poi, int index) async {
    if (poi.audioStoryUrl == null) return;

    setState(() {
      _selectedPoiIndex = index;
      _currentlyPlayingAudio = poi.name;
    });

    try {
      // Tenta usar áudio offline primeiro
      final offlineAudioPath = await _offlineService.getOfflineAudioPath(widget.route.id, poi.id);
      
      if (offlineAudioPath != null && _isAvailableOffline) {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(offlineAudioPath)));
      } else {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(poi.audioStoryUrl!)));
      }
      
      await _audioPlayer.play();
    } catch (e) {
      _showAudioErrorSnackbar();
    }
    await GamificationService.completeRoute(widget.route.title); // ← LINHA ADICIONADA
  }

  /// Pausa a reprodução atual
  void _pauseAudio() {
    _audioPlayer.pause();
  }

  /// Continua a reprodução
  void _resumeAudio() {
    if (_currentlyPlayingAudio != null) {
      _audioPlayer.play();
    }
  }

  /// Mostra erro de áudio
  void _showAudioErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎵 Erro ao carregar áudio. Tente novamente.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Rola a lista para um POI específico
  void _scrollToPoi(int index) {
    if (_scrollController.hasClients) {
      final double scrollOffset = index * 160.0;
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Constrói o cabeçalho da rota com informações principais
  Widget _buildRouteHeader() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e badges
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.route.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // Badges
              if (_isAvailableOffline) ...[
                const SizedBox(width: 8),
                _buildBadge('Offline', Icons.offline_bolt_rounded, Colors.green),
              ],
              if (_averageRating > 0) ...[
                const SizedBox(width: 8),
                _buildBadge(_averageRating.toStringAsFixed(1), Icons.star_rounded, Colors.amber),
              ],
            ],
          ),
          
          const SizedBox(height: 8),
          Text(
            widget.route.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Chips de informações da rota
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.schedule_rounded, widget.route.duration, Colors.blue),
              _buildInfoChip(Icons.alt_route_rounded, widget.route.distance, Colors.green),
              if (widget.route.difficulty != null)
                _buildInfoChip(Icons.terrain_rounded, widget.route.difficulty!, Colors.orange),
              if (widget.route.category != null)
                _buildInfoChip(Icons.category_rounded, widget.route.category!, Colors.purple),
              if (_reviewCount > 0)
                _buildInfoChip(Icons.reviews_rounded, '$_reviewCount avaliações', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói badge informativo
  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      );
  }

  /// Constrói chip de informação com ícone
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a seção do mapa interativo
  Widget _buildMapSection() {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: MapView(
          pointsOfInterest: _pointsOfInterest,
          onPoiSelected: (index) {
            setState(() {
              _selectedPoiIndex = index;
            });
            _scrollToPoi(index);
          },
          initialPoiIndex: _selectedPoiIndex,
        ),
      ),
    );
  }

  /// Constrói o player de áudio flutuante
  Widget _buildAudioPlayerSection() {
    if (_currentlyPlayingAudio == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.culturalOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.culturalOrange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isAvailableOffline ? Icons.offline_bolt_rounded : Icons.record_voice_over_rounded,
                color: AppTheme.culturalOrange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ouvindo: $_currentlyPlayingAudio',
                  style: TextStyle(
                    color: AppTheme.culturalOrange,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isAvailableOffline)
                const Icon(Icons.offline_bolt_rounded, size: 16, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                onPressed: _selectedPoiIndex > 0 
                    ? () => _playPoiAudio(_pointsOfInterest[_selectedPoiIndex - 1], _selectedPoiIndex - 1)
                    : null,
                color: AppTheme.culturalOrange,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
                iconSize: 40,
                onPressed: _isPlaying ? _pauseAudio : _resumeAudio,
                color: AppTheme.culturalOrange,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                onPressed: _selectedPoiIndex < _pointsOfInterest.length - 1
                    ? () => _playPoiAudio(_pointsOfInterest[_selectedPoiIndex + 1], _selectedPoiIndex + 1)
                    : null,
                color: AppTheme.culturalOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói a lista de pontos de interesse
  Widget _buildPoiListSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Pontos de Interesse (${_pointsOfInterest.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque em "Ouvir História" para escutar narrativas dos moradores locais',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _pointsOfInterest.length,
              itemBuilder: (context, index) {
                return _buildPoiCard(_pointsOfInterest[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói card individual para cada ponto de interesse
  Widget _buildPoiCard(PointOfInterest poi, int index) {
    final bool isSelected = index == _selectedPoiIndex;
    final bool hasAudio = poi.audioStoryUrl != null && poi.audioStoryUrl!.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.sustainableGreen.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.sustainableGreen : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(poi.category),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getCategoryIcon(poi.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          poi.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.sustainableGreen : Colors.black87,
          ),
        ),
        subtitle: Text(
          '${poi.estimatedVisitTime ?? 15} min • ${poi.category ?? "Ponto de Interesse"}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: hasAudio
            ? IconButton(
                icon: Icon(
                  _currentlyPlayingAudio == poi.name && _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: AppTheme.culturalOrange,
                ),
                onPressed: () {
                  if (_currentlyPlayingAudio == poi.name && _isPlaying) {
                    _pauseAudio();
                  } else {
                    _playPoiAudio(poi, index);
                  }
                },
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poi.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                if (poi.localTip != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.culturalOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.culturalOrange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: AppTheme.culturalOrange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dica local: ${poi.localTip!}',
                            style: TextStyle(
                              color: AppTheme.culturalOrange,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasAudio) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _playPoiAudio(poi, index),
                      icon: Icon(
                        _isAvailableOffline ? Icons.offline_bolt_rounded : Icons.record_voice_over_rounded,
                      ),
                      label: Text(_isAvailableOffline ? 'Ouvir História (Offline)' : 'Ouvir História do Local'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.culturalOrange,
                        side: BorderSide(color: AppTheme.culturalOrange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a seção de avaliações
  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌟 Avaliações da Comunidade',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Resumo das avaliações
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Rating médio
                  Column(
                    children: [
                      Text(
                        _averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sustainableGreen,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < _averageRating.floor()
                                ? Icons.star_rounded
                                : (index < _averageRating ? Icons.star_half_rounded : Icons.star_border_rounded),
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      Text(
                        '$_reviewCount ${_reviewCount == 1 ? 'avaliação' : 'avaliações'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Compartilhe sua experiência',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ajude outros viajantes contando como foi explorar esta rota',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _showAddReviewDialog,
                          icon: const Icon(Icons.reviews_rounded, size: 18),
                          label: const Text('Deixar Minha Avaliação'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.culturalOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Lista de avaliações
          if (_reviewsLoading)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando avaliações...'),
                ],
              ),
            )
          else if (_reviews.isEmpty)
            _buildEmptyReviewsState()
          else
            Column(
              children: _reviews.map((review) {
                return FutureBuilder<bool>(
                  future: ReviewService.hasUserReviewed(widget.route.id),
                  builder: (context, snapshot) {
                    final isCurrentUser = review['user'] == snapshot.data;
                    return ReviewCard(
                      userName: review['user'],
                      comment: review['comment'],
                      rating: review['rating'].toDouble(),
                      date: DateTime.parse(review['date']),
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Constrói estado vazio para avaliações
  Widget _buildEmptyReviewsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.reviews_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma avaliação ainda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seja o primeiro a compartilhar sua experiência nesta rota!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddReviewDialog,
            icon: const Icon(Icons.add_comment_rounded),
            label: const Text('Escrever Primeira Avaliação'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sustainableGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna cor baseada na categoria do POI
  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'cultural':
        return const Color(0xFFFF9800);
      case 'natureza':
        return const Color(0xFF4CAF50);
      case 'gastronomia':
        return const Color(0xFFF44336);
      default:
        return AppTheme.sustainableGreen;
    }
  }

  /// Retorna ícone baseado na categoria do POI
  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'cultural':
        return Icons.account_balance_rounded;
      case 'natureza':
        return Icons.eco_rounded;
      case 'gastronomia':
        return Icons.restaurant_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Rota'),
        backgroundColor: AppTheme.sustainableGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botão de compartilhamento
          ShareButton(
            routeTitle: widget.route.title,
            routeDescription: widget.route.description,
            routeUrl: "https://tapiocatrips.com/route/${widget.route.id}",
          ),
          // Botão de favoritos
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos',
          ),
          // NOVO BOTÃO: Narrativas Tapioca ← BOTÃO ADICIONADO
          IconButton(
            icon: const Icon(Icons.record_voice_over_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NarrativesScreen(route: widget.route),
                ),
              );
            },
            tooltip: 'Narrativas Tapioca',
          ),
          // Botão de download/remove offline
          if (_isAvailableOffline)
            IconButton(
              icon: const Icon(Icons.offline_bolt_rounded),
              onPressed: _removeOfflineRoute,
              tooltip: 'Remover do Offline',
            )
          else
            IconButton(
              icon: _isDownloading 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download_rounded),
              onPressed: _isDownloading ? null : _showDownloadConfirmation,
              tooltip: 'Baixar para Offline',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho da rota
            _buildRouteHeader(),
            
            // Mapa interativo
            _buildMapSection(),
            
            // Player de áudio
            _buildAudioPlayerSection(),
            
            // Lista de pontos de interesse
            _buildPoiListSection(),
            
            // Seção de avaliações
            _buildReviewsSection(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}