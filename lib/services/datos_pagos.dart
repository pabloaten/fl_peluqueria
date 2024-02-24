import 'dart:convert';

import 'package:fl_peluqueria/models/datos_pagos.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DatosPagoServices extends ChangeNotifier {
  final String _baseURL =
      'granada-style-default-rtdb.europe-west1.firebasedatabase.app';

  final List<DatosPago> datospagos = [];
  DatosPago? datosPagoSeleccionada;
  bool isLoading = true;
  bool isSaving = false;

  DatosPagoServices() {
    this.loadProductos();
  }

  Future<List<DatosPago>> loadProductos() async {
    //this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'DatosPago.json');
    final resp = await http.get(url);

    final Map<String, dynamic> datosPagosMap = json.decode(resp.body);

    datosPagosMap.forEach((key, value) {
      final tempProduct = DatosPago.fromMap(value);
      tempProduct.id = key;
      this.datospagos.add(tempProduct);
    });

    //this.isLoading = false;
    notifyListeners();
    return this.datospagos;
  }

  Future saveOrCreateDatosPago(DatosPago? datoPago) async {
    isSaving = true;
    notifyListeners();

    if (datoPago!.id == null) {
      //Crear
    } else {
      //Actualizar
      await this.updateDatoPago(datoPago!);
    }
  }

  Future<String> updateDatoPago(DatosPago datoPago) async {
    final url = Uri.https(_baseURL, 'DatosPago/${datoPago.id}.json');
    final resp = await http.put(url, body: datoPago.toJson());
    final decodedData = resp.body;

    return datoPago.id!;
  }

}
