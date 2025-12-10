import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// About screen with app information and mission statement
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Tapioca Trips'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Tapioca Trips promotes sustainable and cultural tourism in Piauí, Brazil. '
              'We connect travelers with local stories and authentic experiences through '
              'self-guided routes and audio narratives.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Interactive Maps'),
              subtitle: Text('Navigate routes with offline support'),
            ),
            ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text('Local Audio Stories'),
              subtitle: Text('Hear experiences from residents'),
            ),
            ListTile(
              leading: Icon(Icons.eco),
              title: Text('Sustainable Tourism'),
              subtitle: Text('Support local communities and culture'),
            ),
            Spacer(),
            Center(
              child: Text(
                'Version ${AppConstants.appVersion}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}