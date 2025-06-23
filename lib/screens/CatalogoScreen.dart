import 'package:flutter/material.dart';
import 'package:clase2/navigation/drawer.dart';
import 'package:clase2/screens/PeliculasScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> peliculas = [];
  bool loading = true;
  String? filtroGenero;

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  Future<void> _cargarPeliculas() async {
    setState(() {
      loading = true;
    });

    try {
      var query = supabase.from('peliculas').select();
      if (filtroGenero != null && filtroGenero!.isNotEmpty) {
        query = query.eq('genero', filtroGenero!);
      }

      final response = await query;
      setState(() {
        peliculas = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar películas: $e')),
      );
    }
  }

  void _onGeneroSeleccionado(String? genero) {
    setState(() {
      filtroGenero = genero;
    });
    _cargarPeliculas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Películas")),
      drawer: MiDrawer(onGeneroSeleccionado: _onGeneroSeleccionado),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : peliculas.isEmpty
              ? const Center(child: Text('No hay películas para mostrar'))
              : ListView.builder(
                  itemCount: peliculas.length,
                  itemBuilder: (context, index) {
                    final pelicula = peliculas[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              pelicula['imagen_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          pelicula['titulo'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pelicula['genero'] ?? '',
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 4),
                            Text(pelicula['descripcion']),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Peliculas(
                                titulo: pelicula['titulo'],
                                imagen: pelicula['imagen_url'],
                                descripcion: pelicula['descripcion'],
                                genero: pelicula['genero'],
                                videoFilename: pelicula['video_filename'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
