import 'dart:convert';

class Usuario {
    String email;
    String nombreApellidos;
    String rol;
    String sexo;
    String telefono;

    Usuario({
        required this.email,
        required this.nombreApellidos,
        required this.rol,
        required this.sexo,
        required this.telefono,
    });

    factory Usuario.fromRawJson(String str) => Usuario.fromMap(json.decode(str));

    String toRawJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombreApellidos: json["nombreApellidos"],
        rol: json["rol"],
        sexo: json["sexo"],
        telefono: json["telefono"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "nombreApellidos": nombreApellidos,
        "rol": rol,
        "sexo": sexo,
        "telefono": telefono,
    };
     Usuario copy() => Usuario(
        email: this.email,
        nombreApellidos: this.nombreApellidos,
        rol: this.rol,
        sexo: this.sexo,
        telefono: this.telefono,
       
      );
}

 

