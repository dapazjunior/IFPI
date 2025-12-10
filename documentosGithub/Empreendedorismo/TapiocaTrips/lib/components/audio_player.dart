import 'package:flutter/material.dart';

/// Custom audio player component for playing local stories
/// Will integrate with audio playback services
class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  bool _isPlaying = false;
  double _progress = 0.3; // Mock progress

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Story info
            const ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text('Local Story: Maria\'s Perspective'),
              subtitle: Text('Duration: 5:30'),
            ),
            // Progress bar
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // TODO: Implement previous track
                  },
                ),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                    // TODO: Implement play/pause
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // TODO: Implement next track
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}