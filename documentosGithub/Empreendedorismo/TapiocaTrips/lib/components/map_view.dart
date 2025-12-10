import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Componente AudioPlayer para reprodução de histórias locais
/// Usa o pacote just_audio para controle robusto de áudio
class AudioPlayer extends StatefulWidget {
  final String? audioUrl;
  final String? title;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const AudioPlayer({
    super.key,
    this.audioUrl,
    this.title,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  double _progress = 0.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Configura os listeners do player de áudio
  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
        _isLoading = playerState.processingState == ProcessingState.loading ||
                    playerState.processingState == ProcessingState.buffering;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
        _progress = _duration.inMilliseconds > 0 
            ? position.inMilliseconds / _duration.inMilliseconds 
            : 0.0;
      });
    });

    _audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
          _progress = 0.0;
        });
      }
    });
  }

  /// Configura a fonte de áudio
  Future<void> setAudioSource(AudioSource source) async {
    try {
      await _audioPlayer.setAudioSource(source);
    } catch (e) {
      _showError('Erro ao carregar áudio');
    }
  }

  /// Inicia a reprodução
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      _showError('Erro ao reproduzir áudio');
    }
  }

  /// Pausa a reprodução
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _showError('Erro ao pausar áudio');
    }
  }

  /// Mostra mensagem de erro
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Formata duração para exibição
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Cabeçalho do player
          if (widget.title != null) ...[
            Row(
              children: [
                Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          
          // Barra de progresso
          Column(
            children: [
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.orange.shade700,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Controles do player
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão anterior
              IconButton(
                icon: Icon(
                  Icons.skip_previous_rounded,
                  color: widget.onPrevious != null ? Colors.orange.shade700 : Colors.grey,
                ),
                onPressed: widget.onPrevious,
                iconSize: 32,
              ),
              
              // Botão play/pause
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade700.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                  iconSize: 32,
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_isPlaying) {
                            pause();
                          } else {
                            play();
                          }
                        },
                ),
              ),
              
              // Botão próximo
              IconButton(
                icon: Icon(
                  Icons.skip_next_rounded,
                  color: widget.onNext != null ? Colors.orange.shade700 : Colors.grey,
                ),
                onPressed: widget.onNext,
                iconSize: 32,
              ),
            ],
          ),
          
          // Indicador de estado
          if (_isLoading) ...[
            const SizedBox(height: 8),
            Text(
              'Carregando...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}