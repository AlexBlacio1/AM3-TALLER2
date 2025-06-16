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

class Clase2 extends StatelessWidget {
  const Clase2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Cuerpo());
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MAIN"),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: const Welcome(),
    );
  }
}
