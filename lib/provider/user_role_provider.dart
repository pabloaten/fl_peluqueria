import 'package:fl_peluqueria/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioRoleProvider with ChangeNotifier {
  Usuario? _user;

  Usuario? get user => _user;

  void setUser(Usuario user) {
    _user = user;
    notifyListeners();
  }
}