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


  
}