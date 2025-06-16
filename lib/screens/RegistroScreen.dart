import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'WelcomeScreen.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mensaje'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    final email = correoController.text.trim();
    final password = contrasenaController.text.trim();

    try {

      final response = await supabase
          .from('usuarios')
          .select()
          .eq('correo', email)
          .maybeSingle();

      if (response != null) {
        _mostrarAlerta("El correo ya está registrado.");
        return;
      }


      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        _mostrarAlerta("No se pudo registrar el usuario.");
        return;
      }

      await supabase.from('usuarios').insert({
        'id': authResponse.user!.id,
        'cedula': cedulaController.text.trim(),
        'nombre': nombreController.text.trim(),
        'edad': int.parse(edadController.text.trim()),
        'sexo': sexoController.text.trim(),
        'correo': email,
        'fecha_registro': DateTime.now().toIso8601String(),
      });


      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Éxito'),
          content: const Text('Registro exitoso'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Welcome()),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      _mostrarAlerta("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese su cédula' : null,
              ),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
              ),
              TextFormField(
                controller: edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese su edad' : null,
              ),
              TextFormField(
                controller: sexoController,
                decoration: const InputDecoration(labelText: 'Sexo'),
                validator: (value) => value!.isEmpty ? 'Ingrese su sexo' : null,
              ),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Ingrese su correo' : null,
              ),
              TextFormField(
                controller: contrasenaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registrarUsuario();
                  }
                },
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
