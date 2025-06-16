import 'package:clase2/screens/CatalogoScreen.dart';
import 'package:clase2/screens/PeliculasScreen.dart';
import 'package:flutter/material.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                const Text("APPPIRATA", style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 10),
                Expanded(
                  child: Image.network(
                    "https://i.pinimg.com/originals/ca/04/92/ca049263865283b1dfc1ef476f019d02.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Películas"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Peliculas(
                  titulo: 'Peliculas',
                  imagen: 'https://media.istockphoto.com/id/1159854564/es/vector/ilustraci%C3%B3n-de-emblema-de-cr%C3%A1neo-pirata-con-sables-cruzados.jpg?s=612x612&w=0&k=20&c=cLHe34Uw3tcefFjggxKlclZPRD9-myojLlS2IBEWRiw=',
                  descripcion: 'Aqui aparecerá la descripción de la imagen.',
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Catálogo"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Catalogo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
