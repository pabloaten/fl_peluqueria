import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';

class UsuarioFormProvider extends ChangeNotifier{
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Usuario? usuario;

  UsuarioFormProvider( this.usuario );

  bool isValidForm(){
    print( usuario!.condiciones);
    print( usuario!.contrasea);
    print( usuario!.correo);
    print( usuario!.nombre);
    print( usuario!.notificaciones);
    print( usuario!.sexo);
    print( usuario!.telofono);
    print( usuario!.id);
    print( usuario!.imagen);
    return formKey.currentState?.validate() ?? false;
  }

  


}