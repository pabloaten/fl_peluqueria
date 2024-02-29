import 'dart:convert';

class Reservas {
    bool cancelada;
    List<String> fecha;
    bool pagada;
    int peluquero;
    List<String?> servicios;
    int usuario;

    Reservas({
        required this.cancelada,
        required this.fecha,
        required this.pagada,
        required this.peluquero,
        required this.servicios,
        required this.usuario,
    });

    factory Reservas.fromRawJson(String str) => Reservas.fromMap(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Reservas.fromMap(Map<String, dynamic> json) => Reservas(
        cancelada: json["cancelada"],
        fecha: List<String>.from(json["fecha"].map((x) => x)),
        pagada: json["pagada "],
        peluquero: json["peluquero"],
        servicios: List<String?>.from(json["servicios"].map((x) => x)),
        usuario: json["usuario"],
    );

    Map<String, dynamic> toJson() => {
        "cancelada": cancelada,
        "fecha": List<dynamic>.from(fecha.map((x) => x)),
        "pagada ": pagada,
        "peluquero": peluquero,
        "servicios": List<dynamic>.from(servicios.map((x) => x)),
        "usuario": usuario,
    };
}
