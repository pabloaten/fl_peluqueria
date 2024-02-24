// To parse this JSON data, do
//
//     final datosPago = datosPagoFromMap(jsonString);

import 'dart:convert';

class DatosPago {
  DatosPago({
    required this.cvc,
    required this.fecha,
    required this.numero,
    required this.usuario,
    this.id,
  });

  String? cvc;
  String? fecha;
  String? numero;
  String? usuario;
  String? id;

  factory DatosPago.fromJson(String str) => DatosPago.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosPago.fromMap(Map<String, dynamic> json) => DatosPago(
        cvc: json["CVC"],
        fecha: json["Fecha"],
        numero: json["Numero"],
        usuario: json["Usuario"],
      );

  Map<String, dynamic> toMap() => {
        "CVC": cvc,
        "Fecha": fecha,
        "Numero": numero,
        "Usuario": usuario,
      };
}
