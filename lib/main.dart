import 'package:clase2/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fnxsfutkmaoluazsdmqo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZueHNmdXRrbWFvbHVhenNkbXFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwMDQxOTYsImV4cCI6MjA2NTU4MDE5Nn0.UrX04PA0pjnJmQWNmF4DnI8fd6lSpTHn-fNmBKJvawc',
  );

  runApp(const Clase2());
}

final ThemeData temaClaro = ThemeData.light().copyWith(
  primaryColor: const Color(0xFFE50914),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE50914),
    foregroundColor: Colors.white,
  ),
);

final ThemeData temaOscuro = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFFE50914),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFE50914),
    secondary: Colors.redAccent,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);

class Clase2 extends StatefulWidget {
  const Clase2({super.key});

  @override
  State<Clase2> createState() => _Clase2State();
}

class _Clase2State extends State<Clase2> {
  bool isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP-PIRATA',
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Cuerpo(
        isDarkMode: isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class Cuerpo extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const Cuerpo({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App - Pirata"),
        actions: [
          IconButton(
            onPressed: toggleTheme,
            icon: Icon(
              isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            ),
            tooltip: isDarkMode ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro',
          ),
        ],
      ),
      body: const Welcome(),
    );
  }
}
