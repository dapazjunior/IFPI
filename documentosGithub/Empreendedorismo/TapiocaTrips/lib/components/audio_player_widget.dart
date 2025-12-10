import 'package:flutter/material.dart';
import '../models/poi_model.dart';
import '../services/audio_guide_service.dart';
import '../utils/theme.dart';

/// Widget de player de áudio minimalista que fica fixo na parte inferior
class AudioPlayerWidget extends StatefulWidget {
  final AudioGuideService audioService;

  const AudioPlayerWidget({
    super.key,
    required this.audioService,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioGuideService _audioService;
  PointOfInterest? _currentPOI;
  AudioPlaybackStatus _playbackStatus = AudioPlaybackStatus.stopped;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _audioService = widget.audioService;
    _setupListeners();
  }

  /// Configura os listeners do serviço de áudio
  void _setupListeners() {
    _audioService.currentPOINotifier.addListener(_onCurrentPOIChanged);
    _audioService.playbackNotifier.addListener(_onPlaybackStatusChanged);
  }

  /// Atualiza quando o POI atual muda
  void _onCurrentPOIChanged() {
    if (mounted) {
      setState(() {
        _currentPOI = _audioService.currentPOINotifier.value;
      });
    }
  }

  /// Atualiza quando o status de reprodução muda
  void _onPlaybackStatusChanged() {
    if (mounted) {
      setState(() {
        _playbackStatus = _audioService.playbackNotifier.value;
      });
    }
  }

  /// Alterna entre expandido e recolhido
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Formata duração para exibição
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Retorna ícone baseado no status de reprodução
  IconData _getPlaybackIcon() {
    switch (_playbackStatus) {
      case AudioPlaybackStatus.playing:
        return Icons.pause_rounded;
      case AudioPlaybackStatus.paused:
        return Icons.play_arrow_rounded;
      case AudioPlaybackStatus.loading:
        return Icons.hourglass_top_rounded;
      case AudioPlaybackStatus.stopped:
        return Icons.play_arrow_rounded;
      case AudioPlaybackStatus.error:
        return Icons.error_outline_rounded;
      default:
        return Icons.play_arrow_rounded;
    }
  }

  /// Retorna cor baseada no status de reprodução
  Color _getPlaybackColor() {
    switch (_playbackStatus) {
      case AudioPlaybackStatus.playing:
        return AppTheme.culturalOrange;
      case AudioPlaybackStatus.paused:
        return Colors.grey;
      case AudioPlaybackStatus.loading:
        return Colors.blue;
      case AudioPlaybackStatus.stopped:
        return Colors.grey;
      case AudioPlaybackStatus.error:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Esconde o widget se não há áudio para reproduzir
    if (_currentPOI == null && _playbackStatus == AudioPlaybackStatus.stopped) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? 120 : 80,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppTheme.sustainableGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Cabeçalho do player
            _buildPlayerHeader(),
            
            // Conteúdo expandido (se aplicável)
            if (_isExpanded && _currentPOI != null) 
              _buildExpandedContent(),
          ],
        ),
      ),
    );
  }

  /// Constrói o cabeçalho do player
  Widget _buildPlayerHeader() {
    return ListTile(
      leading: _buildPlaybackButton(),
      title: _currentPOI != null
          ? Text(
              _currentPOI!.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const Text(
              'Narrativa Tapioca',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
      subtitle: _currentPOI != null
          ? Text(
              _currentPOI!.narratorName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador offline
          if (_currentPOI?.isAudioAvailableOffline == true)
            Icon(
              Icons.offline_bolt_rounded,
              size: 16,
              color: Colors.green,
            ),
          
          const SizedBox(width: 8),
          
          // Botão expandir/recolher
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              size: 20,
            ),
            onPressed: _toggleExpanded,
          ),
        ],
      ),
      onTap: _toggleExpanded,
    );
  }

  /// Constrói o botão de reprodução
  Widget _buildPlaybackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getPlaybackColor().withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: _getPlaybackColor(),
          width: 2,
        ),
      ),
      child: IconButton(
        icon: _playbackStatus == AudioPlaybackStatus.loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getPlaybackColor()),
                ),
              )
            : Icon(
                _getPlaybackIcon(),
                size: 20,
                color: _getPlaybackColor(),
              ),
        onPressed: _handlePlaybackAction,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Constrói conteúdo expandido
  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          
          // Descrição do POI
          Text(
            _currentPOI?.description ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // Controles adicionais
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão parar
              TextButton.icon(
                icon: const Icon(Icons.stop_rounded, size: 16),
                label: const Text('Parar'),
                onPressed: _stopAudio,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
              ),
              
              // Status de reprodução
              Text(
                _getPlaybackStatusText(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              // Botão fechar
              TextButton.icon(
                icon: const Icon(Icons.close_rounded, size: 16),
                label: const Text('Fechar'),
                onPressed: _closePlayer,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Manipula ação de reprodução/pausa
  void _handlePlaybackAction() async {
    try {
      switch (_playbackStatus) {
        case AudioPlaybackStatus.playing:
          await _audioService.pauseAudio();
          break;
        case AudioPlaybackStatus.paused:
          await _audioService.resumeAudio();
          break;
        case AudioPlaybackStatus.stopped:
          if (_currentPOI != null) {
            await _audioService.playPOIAudio(_currentPOI!);
          }
          break;
        case AudioPlaybackStatus.loading:
          // Não faz nada durante carregamento
          break;
        case AudioPlaybackStatus.error:
          // Tenta reproduzir novamente em caso de erro
          if (_currentPOI != null) {
            await _audioService.playPOIAudio(_currentPOI!);
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao controlar reprodução: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Para a reprodução
  void _stopAudio() async {
    await _audioService.stopAudio();
    setState(() {
      _isExpanded = false;
    });
  }

  /// Fecha o player
  void _closePlayer() async {
    await _stopAudio();
    setState(() {
      _currentPOI = null;
      _isExpanded = false;
    });
  }

  /// Retorna texto do status de reprodução
  String _getPlaybackStatusText() {
    switch (_playbackStatus) {
      case AudioPlaybackStatus.playing:
        return 'Reproduzindo...';
      case AudioPlaybackStatus.paused:
        return 'Pausado';
      case AudioPlaybackStatus.loading:
        return 'Carregando...';
      case AudioPlaybackStatus.stopped:
        return 'Parado';
      case AudioPlaybackStatus.error:
        return 'Erro';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _audioService.currentPOINotifier.removeListener(_onCurrentPOIChanged);
    _audioService.playbackNotifier.removeListener(_onPlaybackStatusChanged);
    super.dispose();
  }
}