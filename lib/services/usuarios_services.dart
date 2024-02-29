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
    this.loadProductos();
  }

  Future<List<Usuario>> loadProductos() async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseURL, 'usuarios.json' );
    final resp = await http.get( url );

    final Map<String, dynamic> productosMap = json.decode(resp.body);

    productosMap.forEach((key, value) {
      final tempProduct = Usuario.fromMap ( value );
     
      this.usuarios.add (tempProduct);

    });
    
    this.isLoading = false;
    notifyListeners();

    return usuarios;
    //print(this.producto[1].nombre);
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
  
}