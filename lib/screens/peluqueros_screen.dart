import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:fl_peluqueria/services/usuarios_services.dart';
import 'package:provider/provider.dart';

class PeluquerosScreen extends StatelessWidget {
  const PeluquerosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: Consumer<UsuariosServices>(
        builder: (context, usuariosServices, _) {
          if (usuariosServices.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: usuariosServices.usuarios.length,
              itemBuilder: (context, index) {
                final Usuario usuario = usuariosServices.usuarios[index];
                return ListTile(
                  title: Text(usuario.nombreApellidos),
                  subtitle: Text(usuario.email),
                  onTap: () {
                    // Acción al hacer tap en el usuario
                    // Por ejemplo, puedes navegar a otra pantalla para ver más detalles del usuario
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
