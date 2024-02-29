import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';

class PeluqueroCard extends StatelessWidget {
  final Usuario usuario;

  const PeluqueroCard({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person, color: Colors.red,),
          
        ),
        title: Text(usuario.nombreApellidos ?? ''),
        subtitle: Text(usuario.email ?? ''),
        
        // Puedes agregar más información del usuario aquí, como el correo electrónico, etc.
      ),
    );
  }
}