import 'dart:convert';

import 'package:fl_peluqueria/models/usuario.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class UsuariosServices extends ChangeNotifier {
  final String _baseURL =
      'fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Usuario> usuarios = [];
  Usuario? usuarioSeleccionado;

  bool isSaving = false;
  bool isLoading = true;

 UsuariosServices(){
    this.loadUsarios();
  }

  Future<List<Usuario>> loadUsarios() async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseURL, 'usuarios.json' );
    final resp = await http.get( url );

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUsuario = Usuario.fromMap ( value );
      //tempUsuario.email = key;
      this.usuarios.add (tempUsuario);

    });
    
    this.isLoading = false;
    notifyListeners();

    return usuarios;
    //print(this.usuario[1].nombreApellidos);
  }

 Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    try {
      // Realiza la búsqueda local en la lista de usuarios
      Usuario? usuarioEncontrado = usuarios.firstWhere(
        (usuario) => usuario.email == email,
        
      );

      // Si se encuentra el usuario localmente, devuelve la instancia
      if (usuarioEncontrado != null) {
        return usuarioEncontrado;
      }

      // Si no se encuentra localmente, realiza la búsqueda en la base de datos
      final url = Uri.https(_baseURL, 'usuarios.json');
      final resp = await http.get(url);

      final Map<String, dynamic> usuariosMap = json.decode(resp.body);

      if (usuariosMap.isNotEmpty) {
        // Itera sobre los usuarios en la base de datos para buscar por correo electrónico
        for (var key in usuariosMap.keys) {
          final usuarioData = usuariosMap[key];
          if (usuarioData['email'] == email) {
            final usuario = Usuario.fromMap(usuarioData);
            return usuario;
          }
        }
      }

      // Si no se encuentra ningún usuario con el correo electrónico dado, devuelve null
      return null;
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir durante la búsqueda
      print('Error al buscar usuario por email: $e');
      return null;
    }
  }

  Future<String?> updateUsuario(Usuario usuario, String email) async {
  final url = Uri.https(_baseURL, 'usuarios/$email.json');
  
  try {
    final resp = await http.put(url, body: usuario.toRawJson());
    
    if (resp.statusCode == 200) {
      // Notificar a los escuchadores que se ha actualizado el usuario correctamente
      notifyListeners();
      
      return usuario.email;
    } else {
      // Manejar el caso en el que la solicitud no se completó con éxito
      print('Error al actualizar el usuario: ${resp.statusCode}');
      return null;
    }
  } catch (error) {
    // Manejar el caso en el que ocurrió un error durante la solicitud
    print('Error al actualizar el usuario: $error');
    return null;
  }
}

}