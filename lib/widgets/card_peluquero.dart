import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';

class PeluqueroCard extends StatelessWidget {
  final Usuario usuario;

  const PeluqueroCard({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          // Aquí podrías cargar la imagen del usuario si está disponible
          // Ejemplo: usuario.imagen != null ? Image.network(usuario.imagen!) : Icon(Icons.person),
          child: Icon(Icons.person),
        ),
        title: Text(usuario.nombre ?? ''),
        subtitle: Text(usuario.correo ?? ''),
        // Puedes agregar más información del usuario aquí, como el correo electrónico, etc.
      ),
    );
  }
}
