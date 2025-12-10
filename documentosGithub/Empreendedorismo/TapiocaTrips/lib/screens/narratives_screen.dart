import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/poi_model.dart';
import '../services/audio_guide_service.dart';
import '../components/audio_player_widget.dart';
import '../utils/theme.dart';

/// Tela de Narrativas Tapioca - Lista de pontos de interesse com áudio-guia
class NarrativesScreen extends StatefulWidget {
  final TourismRoute route;

  const NarrativesScreen({
    super.key,
    required this.route,
  });

  @override
  State<NarrativesScreen> createState() => _NarrativesScreenState();
}

class _NarrativesScreenState extends State<NarrativesScreen> {
  final AudioGuideService _audioService = AudioGuideService();
  List<PointOfInterest> _pois = [];
  bool _isLoading = true;
  bool _autoPlayEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  /// Inicializa a tela
  Future<void> _initializeScreen() async {
    await _audioService.initialize();
    
    // Carrega POIs da rota
    _pois = widget.route.pointsOfInterest ?? _getMockPOIs();
    
    // Inicia monitoramento de localização
    await _audioService.startRouteMonitoring(_pois);
    
    // Carrega preferências
    _autoPlayEnabled = _audioService.autoPlayEnabled;
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Mock data para desenvolvimento
  List<PointOfInterest> _getMockPOIs() {
    return [
      PointOfInterest(
        id: '1',
        name: 'Porto das Barcas',
        description: 'Centro histórico com arquitetura do século XIX',
        latitude: -5.0892,
        longitude: -42.8016,
        audioStoryUrl: 'https://example.com/audio/porto_barcas.mp3',
        estimatedVisitTime: 30,
        category: 'Cultural',
        narratorName: 'Seu Antônio - Comerciante Local',
        audioDuration: 180.0,
      ),
      PointOfInterest(
        id: '2',
        name: 'Mirante do Rio Parnaíba',
        description: 'Vista panorâmica do encontro do rio com o mar',
        latitude: -5.0915,
        longitude: -42.8031,
        audioStoryUrl: 'https://example.com/audio/mirante_parnaiba.mp3',
        estimatedVisitTime: 20,
        category: 'Natureza',
        narratorName: 'Dona Maria - Pescadora',
        audioDuration: 150.0,
      ),
      PointOfInterest(
        id: '3',
        name: 'Mercado Público',
        description: 'Experimente sabores locais e tradições culinárias',
        latitude: -5.0881,
        longitude: -42.7998,
        audioStoryUrl: 'https://example.com/audio/mercado_publico.mp3',
        estimatedVisitTime: 45,
        category: 'Gastronomia',
        narratorName: 'Zé da Tapioca - Vendedor',
        audioDuration: 210.0,
      ),
    ];
  }

  /// Baixa áudio de um POI
  Future<void> _downloadPOIAudio(PointOfInterest poi) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Baixando áudio: ${poi.name}...'),
          backgroundColor: Colors.blue,
        ),
      );
    }

    final success = await _audioService.downloadPOIAudio(poi);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success 
                ? '✅ Áudio baixado com sucesso!'
                : '❌ Erro ao baixar áudio',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      
      if (success) {
        setState(() {
          // Atualiza a lista local
          final index = _pois.indexWhere((p) => p.id == poi.id);
          if (index != -1) {
            _pois[index] = _pois[index].markAsDownloaded(poi.localAudioPath!);
          }
        });
      }
    }
  }

  /// Reproduz áudio de um POI
  Future<void> _playPOIAudio(PointOfInterest poi) async {
    try {
      await _audioService.playPOIAudio(poi);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao reproduzir áudio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Alterna reprodução automática
  Future<void> _toggleAutoPlay() async {
    await _audioService.toggleAutoPlay();
    if (mounted) {
      setState(() {
        _autoPlayEnabled = _audioService.autoPlayEnabled;
      });
    }
  }

  /// Constrói a lista de POIs
  Widget _buildPOIsList() {
    if (_pois.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pois.length,
      itemBuilder: (context, index) {
        final poi = _pois[index];
        return _buildPOICard(poi);
      },
    );
  }

  /// Constrói card de POI
  Widget _buildPOICard(PointOfInterest poi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com nome e distância
            Row(
              children: [
                Expanded(
                  child: Text(
                    poi.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildDistanceIndicator(poi),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Narrador e categoria
            Row(
              children: [
                Icon(
                  Icons.record_voice_over_rounded,
                  size: 14,
                  color: AppTheme.culturalOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  poi.narratorName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(poi.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    poi.category ?? 'Geral',
                    style: TextStyle(
                      fontSize: 10,
                      color: _getCategoryColor(poi.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Descrição
            Text(
              poi.description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Controles de áudio
            _buildAudioControls(poi),
          ],
        ),
      ),
    );
  }

  /// Constrói indicador de distância
  Widget _buildDistanceIndicator(PointOfInterest poi) {
    // Em uma implementação real, isso viria do serviço de geolocalização
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 12, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            'Próximo',
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói controles de áudio para um POI
  Widget _buildAudioControls(PointOfInterest poi) {
    final hasAudio = poi.hasAudio;
    final isDownloaded = poi.isAudioAvailableOffline;

    return Row(
      children: [
        // Botão play
        if (hasAudio)
          ElevatedButton.icon(
            onPressed: () => _playPOIAudio(poi),
            icon: const Icon(Icons.play_arrow_rounded, size: 16),
            label: const Text('Ouvir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sustainableGreen,
              foregroundColor: Colors.white,
            ),
          ),
        
        const SizedBox(width: 8),
        
        // Botão download
        if (hasAudio && !isDownloaded)
          OutlinedButton.icon(
            onPressed: () => _downloadPOIAudio(poi),
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Baixar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        
        // Indicador offline
        if (isDownloaded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.offline_bolt_rounded, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Offline',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        
        const Spacer(),
        
        // Duração do áudio
        if (hasAudio)
          Text(
            poi.formattedDuration,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  /// Constrói estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.record_voice_over_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum ponto de interesse com áudio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta rota ainda não possui narrativas disponíveis',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna cor baseada na categoria
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Narrativas Tapioca'),
        backgroundColor: AppTheme.sustainableGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botão para alternar reprodução automática
          IconButton(
            icon: Icon(
              _autoPlayEnabled 
                  ? Icons.notifications_active_rounded 
                  : Icons.notifications_off_rounded,
            ),
            onPressed: _toggleAutoPlay,
            tooltip: _autoPlayEnabled 
                ? 'Desativar sugestões automáticas' 
                : 'Ativar sugestões automáticas',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Lista de POIs
                _buildPOIsList(),
                
                // Player de áudio fixo na parte inferior
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AudioPlayerWidget(audioService: _audioService),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}