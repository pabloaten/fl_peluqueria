import 'dart:convert';

import 'package:fl_peluqueria/models/usuario.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class UsuariosServices extends ChangeNotifier {
  final String _baseURL =
      'https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Usuario> usuarios = [];
  Usuario? usuarioSeleccionado;

  bool isSaving = false;
  bool isLoading = true;

  UsuariosServices() {
    this.loadProductos();
  }

  Future<List<Usuario>> loadProductos() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'Usuarios.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempProduct = Usuario.fromMap(value);
      tempProduct.id = key;
      this.usuarios.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();
    return usuarios;
  }

  Future saveOrCreateUsuario(Usuario usuario) async {
    isSaving = true;
    notifyListeners();

    if (usuario.id == null) {
      //Crear
    } else {
      //Actualizar
      await this.updateUsuario(usuario!);
    }
  }

  Future<String> updateUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'Usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    final decodedData = resp.body;

    print( decodedData);

    return usuario.id!;
  }
}
