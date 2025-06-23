import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _imagenPerfil;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imagenPerfil = File(pickedFile.path);
      });
    }
  }

  Future<String?> _subirImagenPerfil(String userId) async {
    if (_imagenPerfil == null) return null;

    final path = 'perfil/$userId.jpg';

    try {
      // Intentar eliminar archivo previo para evitar error al subir
      await supabase.storage.from('perfil').remove([path]);
    } catch (e) {
      debugPrint('No se pudo eliminar archivo previo: $e');
    }

    try {
      final res = await supabase.storage.from('perfil').upload(path, _imagenPerfil!);
      debugPrint('Archivo subido con éxito: $res');

      final publicUrl = supabase.storage.from('perfil').getPublicUrl(path);
      debugPrint('URL pública de imagen: $publicUrl');

      return publicUrl;
    } catch (e) {
      debugPrint('Error al subir imagen: $e');
      return null;
    }
  }

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

  bool _validarEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> _registrarUsuario() async {
    final email = correoController.text.trim();
    final password = contrasenaController.text.trim();

    if (!_validarEmail(email)) {
      _mostrarAlerta("Ingrese un correo válido.");
      return;
    }

    final edad = int.tryParse(edadController.text.trim());
    if (edad == null || edad <= 0) {
      _mostrarAlerta("Ingrese una edad válida.");
      return;
    }

    if (_imagenPerfil == null) {
      _mostrarAlerta("Seleccione una foto de perfil.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase.from('usuarios').select().eq('correo', email).maybeSingle();

      if (response != null) {
        _mostrarAlerta("El correo ya está registrado.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final authResponse = await supabase.auth.signUp(email: email, password: password);

      if (authResponse.user == null) {
        _mostrarAlerta("No se pudo registrar el usuario.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final fotoPerfilUrl = await _subirImagenPerfil(authResponse.user!.id);
      debugPrint('URL imagen perfil: $fotoPerfilUrl');

      if (fotoPerfilUrl == null || fotoPerfilUrl.isEmpty) {
        _mostrarAlerta("Error al subir la imagen de perfil.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await supabase.from('usuarios').insert({
        'id': authResponse.user!.id,
        'cedula': cedulaController.text.trim(),
        'nombre': nombreController.text.trim(),
        'edad': edad,
        'sexo': sexoController.text.trim(),
        'correo': email,
        'fecha_registro': DateTime.now().toIso8601String(),
        'foto_perfil_url': fotoPerfilUrl,
      });

      setState(() {
        _isLoading = false;
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
      setState(() {
        _isLoading = false;
      });
      _mostrarAlerta("Error: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    cedulaController.dispose();
    nombreController.dispose();
    edadController.dispose();
    sexoController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
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
              GestureDetector(
                onTap: _seleccionarImagen,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imagenPerfil != null ? FileImage(_imagenPerfil!) : null,
                  child: _imagenPerfil == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
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
                validator: (value) {
                  final edad = int.tryParse(value ?? '');
                  if (edad == null || edad <= 0) {
                    return 'Ingrese una edad válida';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese su correo';
                  if (!_validarEmail(value)) return 'Ingrese un correo válido';
                  return null;
                },
              ),
              TextFormField(
                controller: contrasenaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
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
