import 'package:clase2/screens/LoginScreen.dart';
import 'package:clase2/screens/RegistroScreen.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido a APP-PIRATA",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                ),
                child: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Registro()),
                ),
                icon: const Icon(Icons.person_add),
                label: const Text("Registrarse"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
