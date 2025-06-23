import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clase2/screens/VideoScreen.dart';
import 'package:clase2/screens/YoutubeTrailerScreen.dart';

class Peliculas extends StatelessWidget {
  final String titulo;
  final String imagen;
  final String descripcion;
  final String genero;
  final String videoFilename;

  const Peliculas({
    super.key,
    required this.titulo,
    required this.imagen,
    required this.descripcion,
    required this.genero,
    required this.videoFilename,
  });

  static final Map<String, String> trailerLinks = {
    'Piratas del Caribe': 'https://www.youtube.com/watch?v=tnx35Z4nWWc',
    'Resident Evil': 'https://www.youtube.com/watch?v=cMRt9hHkljA',
    'Lilo y Stich': 'https://www.youtube.com/watch?v=5rJU6N7vNAQ',
    'Peter Pan': 'https://www.youtube.com/watch?v=ePmWSiYU1o4',
    'El planeta del Tesoro': 'https://www.youtube.com/watch?v=0QOfbX9Hg7E',
    'Rápidos y Furiosos': 'https://www.youtube.com/watch?v=-oJHZre7XZY',
    'Sherk': 'https://www.youtube.com/watch?v=TMIsxOsuwNA',
    'Super Mario Bros.': 'https://www.youtube.com/watch?v=SvJwEiy2Wok',
    'Gardfield': 'https://www.youtube.com/watch?v=GeR3YxTv_zU',
    'Todos queremos a Goofy': 'https://www.youtube.com/watch?v=t85wMyWinr0',
  };

  Future<void> _verPelicula(BuildContext context) async {
    final supabase = Supabase.instance.client;

    try {
      final url = await supabase.storage
          .from('peliculas')
          .createSignedUrl(videoFilename, 3600);

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoScreen(videoUrl: url)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la película: $e')),
      );
    }
  }

  void _verTrailer(BuildContext context) {
    final url = trailerLinks[titulo];
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tráiler no disponible para esta película.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => YouTubeTrailerScreen(youtubeUrl: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                image: DecorationImage(
                  image: NetworkImage(imagen),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(genero, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => _verPelicula(context),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text("Ver Película"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
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
