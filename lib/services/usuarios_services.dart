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

    final Map<String, dynamic> productosMap = json.decode(resp.body);

    productosMap.forEach((key, value) {
      final tempProduct = Usuario.fromMap ( value );
     
      this.usuarios.add (tempProduct);

    });
    
    this.isLoading = false;
    notifyListeners();

    return usuarios;
  }

  Future<String?> updateUsuario(Usuario usuario) async {
  final url = Uri.https(_baseURL, 'usuarios/${usuario.email}.json');
  
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