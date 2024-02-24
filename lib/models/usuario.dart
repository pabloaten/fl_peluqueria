import 'dart:convert';
class Usuario {
  Usuario({
    required this.condiciones,
    required this.contrasea,
    required this.correo,
    required this.nombre,
    required this.notificaciones,
    required this.sexo,
    required this.telofono,
    this.id,
    this.imagen,
  });

  bool? condiciones;
  String? contrasea;
  String? correo;
  String? nombre;
  bool? notificaciones;
  String? sexo;
  String? telofono;
  String? id;
  String? imagen;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        condiciones: json["Condiciones"],
        contrasea: json["Contraseña"],
        correo: json["Correo"],
        nombre: json["Nombre"],
        notificaciones: json["Notificaciones"],
        sexo: json["Sexo"],
        telofono: json["Telofono"],
        imagen: json["Imagen"],
      );

  Map<String, dynamic> toMap() => {
        "Condiciones": condiciones,
        "Contraseña": contrasea,
        "Correo": correo,
        "Nombre": nombre,
        "Notificaciones": notificaciones,
        "Sexo": sexo,
        "Telofono": telofono,
        "imagen": imagen,
      };
}