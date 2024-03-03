import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:fl_peluqueria/services/usuarios_services.dart';
import 'package:provider/provider.dart';
import 'package:fl_peluqueria/screens/editar_usuario.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class PeluquerosScreen extends StatefulWidget {
  const PeluquerosScreen({Key? key}) : super(key: key);

  @override
  State<PeluquerosScreen> createState() => _PeluquerosScreenState();
}

class _PeluquerosScreenState extends State<PeluquerosScreen> {

  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: Text('Lista de Usuarios'),
        onSearch: (value) => setState(() => searchValue = value),
      ),
      body: Consumer<UsuariosServices>(
        builder: (context, usuariosServices, _) {
          if (usuariosServices.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Filtrar usuarios basados en el valor de búsqueda, en este caso nombre y apellidos
            final List<Usuario> filteredUsers = usuariosServices.usuarios.where((usuario) {
              return usuario.nombreApellidos.toLowerCase().contains(searchValue.toLowerCase());
            }).toList();
            
            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final Usuario usuario = filteredUsers[index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(usuario.nombreApellidos),
                  subtitle: Text(usuario.email + "        " + usuario.telefono + "        " + usuario.sexo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarUsuarioScreen(usuario: usuario, usuariosServices: usuariosServices),
                      ),
                    );
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

