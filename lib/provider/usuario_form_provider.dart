import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';

class UsuarioFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Usuario? usuario;

  UsuarioFormProvider(this.usuario);

  bool isValidForm() {
    if (usuario != null) {
      print(usuario!.email);
      print(usuario!.nombreApellidos);
      print(usuario!.rol);
      print(usuario!.sexo);
      print(usuario!.telefono);
    }
    return formKey.currentState?.validate() ?? false;
  }
}
