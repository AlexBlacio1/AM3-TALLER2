import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MiDrawer extends StatefulWidget {
  final Function(String?) onGeneroSeleccionado;

  const MiDrawer({super.key, required this.onGeneroSeleccionado});

  @override
  State<MiDrawer> createState() => _MiDrawerState();
}

class _MiDrawerState extends State<MiDrawer> with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  String? nombreUsuario;
  String? fotoPerfilUrl;
  bool loadingUsuario = true;

  final List<String> generos = [
    'Acción',
    'Aventura',
    'Comedia',
    'Drama',
    'Terror',
    'Animación',
    'Ciencia ficción',

  ];

  late AnimationController _animController;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shadowAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosUsuario() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        loadingUsuario = false;
      });
      return;
    }

    try {
      final data = await supabase
          .from('usuarios')
          .select('nombre, foto_perfil_url')
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        setState(() {
          nombreUsuario = data['nombre'] as String?;
          fotoPerfilUrl = data['foto_perfil_url'] as String?;
          loadingUsuario = false;
        });
      } else {
        setState(() {
          loadingUsuario = false;
        });
      }
    } catch (e) {
      setState(() {
        loadingUsuario = false;
      });
      debugPrint('Error cargando datos usuario: $e');
    }
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.red.withOpacity(0.3),
      highlightColor: Colors.red.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.redAccent),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF121212),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _shadowAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.7),
                        blurRadius: _shadowAnimation.value,
                        spreadRadius: _shadowAnimation.value / 2,
                        offset: Offset(0, _shadowAnimation.value / 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: const Text(
                    'APP-PIRATA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE50914),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              color: const Color(0xFF222222),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: (fotoPerfilUrl != null && fotoPerfilUrl!.isNotEmpty)
                        ? NetworkImage(fotoPerfilUrl!)
                        : null,
                    child: (fotoPerfilUrl == null || fotoPerfilUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 40, color: Colors.white70)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: loadingUsuario
                        ? const Text(
                            'Cargando...',
                            style: TextStyle(color: Colors.white70, fontSize: 18),
                          )
                        : Text(
                            nombreUsuario ?? 'Usuario',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(
                    icon: Icons.movie,
                    title: "Catálogo de Películas",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/catalogo');
                    },
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      'Filtrar por género',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...generos.map(
                    (genero) => InkWell(
                      onTap: () {
                        widget.onGeneroSeleccionado(genero);
                        Navigator.pop(context);
                      },
                      splashColor: Colors.red.withOpacity(0.3),
                      highlightColor: Colors.red.withOpacity(0.1),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          genero,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onGeneroSeleccionado(null);
                      Navigator.pop(context);
                    },
                    splashColor: Colors.red.withOpacity(0.3),
                    highlightColor: Colors.red.withOpacity(0.1),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: const Text(
                        'Mostrar todas',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
