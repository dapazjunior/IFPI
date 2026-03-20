import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const EnfermeiroAgilApp());
}

class EnfermeiroAgilApp extends StatelessWidget {
  const EnfermeiroAgilApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Verifica se já tem sessão ativa
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Enfermeiro Ágil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: session != null ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
