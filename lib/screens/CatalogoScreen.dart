import 'package:clase2/navigation/drawer.dart';
import 'package:clase2/screens/PeliculasScreen.dart';
import 'package:flutter/material.dart';

class Catalogo extends StatelessWidget {
  const Catalogo({super.key});

  final List<Map<String, String>> peliculas = const [
    {
      'titulo': 'Pirata del Caribe',
      'imagen': 'https://es.web.img3.acsta.net/c_310_420/pictures/14/03/25/11/14/498694.jpg',
      'descripcion': 'Lorem ipsum dolor sit amet, aventuras en alta mar...'
    },
    {
      'titulo': 'El Tesoro Fantasma',
      'imagen': 'https://images.cdn1.buscalibre.com/fit-in/360x360/83/36/83363b01a59df1f71adc0e46e5b45e92.jpg',
      'descripcion': 'Una historia épica llena de misterios y batallas.'
    },
    {
      'titulo': 'Lilo y Stich',
      'imagen': 'https://m.media-amazon.com/images/S/pv-target-images/82358a68004ba7346674d1b392509258eaef1add6192f032454a619e8e51b9a0.jpg',
      'descripcion': 'Lorem ipsum dolor sit amet.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Películas")),
      drawer: const MiDrawer(),
      body: ListView.builder(
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          final pelicula = peliculas[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(pelicula['imagen']!, width: 50, fit: BoxFit.cover),
              title: Text(pelicula['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pelicula['descripcion']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Peliculas(
                      titulo: pelicula['titulo']!,
                      imagen: pelicula['imagen']!,
                      descripcion: pelicula['descripcion']!,
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
