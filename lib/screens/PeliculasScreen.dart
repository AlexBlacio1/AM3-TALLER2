import 'package:flutter/material.dart';
import 'package:clase2/navigation/drawer.dart';
import 'package:clase2/screens/VideoScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Peliculas extends StatelessWidget {
  final String titulo;
  final String imagen;
  final String descripcion;

  const Peliculas({
    super.key,
    required this.titulo,
    required this.imagen,
    required this.descripcion,
  });

  Future<void> _verTrailer(BuildContext context) async {
    final supabase = Supabase.instance.client;


    final Map<String, String> trailerMap = {
      'Lilo y Stich': 'Lilo.mp4',
    };

   
    if (!trailerMap.containsKey(titulo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tráiler no disponible para esta película.')),
      );
      return;
    }

    final archivo = trailerMap[titulo]!;

    try {
      final url = await supabase.storage
          .from('12')
          .createSignedUrl(archivo, 60 * 60);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoScreen(videoUrl: url),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el tráiler: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      drawer: const MiDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(imagen),
            const SizedBox(height: 16),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ver Película aún no disponible')),
                    );
                  },
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text("Ver Película"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _verTrailer(context),
                  icon: const Icon(Icons.movie),
                  label: const Text("Ver Tráiler"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
