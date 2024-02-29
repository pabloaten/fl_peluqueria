import 'dart:convert';

import 'package:fl_peluqueria/models/reservas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservasServices extends ChangeNotifier {
  final String _baseURL =
      'fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Reservas> reservas = [];
  Reservas? reservaSeleccionada;

  bool isSaving = false;
  bool isLoading = true;

  ReservasServices() {
    this.loadReservas();
  }

  Future<List<Reservas>> loadReservas() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'reservas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> reservasMap = json.decode(resp.body);

    reservasMap.forEach((key, value) {
      final tempReserva = Reservas.fromMap(value);
      this.reservas.add(tempReserva);
    });

    this.isLoading = false;
    notifyListeners();

    return reservas;
  }
}
