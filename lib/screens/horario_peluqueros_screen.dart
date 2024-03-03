import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HorarioPeluquerosScreen extends StatefulWidget {
  @override
  _HorarioPeluqueroScreenState createState() => _HorarioPeluqueroScreenState();
}

class _HorarioPeluqueroScreenState extends State<HorarioPeluquerosScreen> {
  late TimeOfDay morningOpeningTime; // Hora de apertura de la peluquería
  late TimeOfDay morningClosingTime; // Hora de cierre de la peluquería
  late TimeOfDay tardeOpeningTime; // Hora de apertura de la tarde
  late TimeOfDay tardeClosingTime; // Hora de cierre de la tarde

  final String databaseURL =
      'https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app/';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerHorarioDesdeBD('hor001');
  }

  Future<void> obtenerHorarioDesdeBD(String horarioId) async {
    final Uri url = Uri.parse('$databaseURL/horarios/$horarioId.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          morningOpeningTime = _parseTime(data['AperMan']);
          morningClosingTime = _parseTime(data['CieMan']);
          tardeOpeningTime = _parseTime(data['AperTar']);
          tardeClosingTime = _parseTime(data['CieTar']);
          isLoading = false;
        });
      } else {
        throw Exception('Error al recuperar datos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al recuperar datos: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final List<String> parts = timeString.split(' ');
    final List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    final int minutes = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hours < 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario Peluquero'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: calculateTimeSlots(
                              morningOpeningTime, morningClosingTime)
                          .length,
                      itemBuilder: (context, index) {
                        final time = calculateTimeSlots(
                            morningOpeningTime, morningClosingTime)[index];
                        return ElevatedButton(
                          onPressed: () {
                            // Lógica para manejar el botón presionado
                          },
                          child: Text('${time.hour}:${time.minute}'),
                        );
                      },
                    ),
                  ),
                ),
                Divider(), // Línea divisoria
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 2.0,
                      ),
                      itemCount:
                          calculateTimeSlots(tardeOpeningTime, tardeClosingTime)
                              .length,
                      itemBuilder: (context, index) {
                        final time = calculateTimeSlots(
                            tardeOpeningTime, tardeClosingTime)[index];
                        return ElevatedButton(
                          onPressed: () {
                            // Lógica para manejar el botón presionado
                          },
                          child: Text('${time.hour}:${time.minute}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<TimeOfDay> calculateTimeSlots(
      TimeOfDay openingTime, TimeOfDay closingTime) {
    List<TimeOfDay> slots = [];
    TimeOfDay currentTime = openingTime;

    while (currentTime.hour < closingTime.hour ||
        (currentTime.hour == closingTime.hour &&
            currentTime.minute <= closingTime.minute)) {
      slots.add(currentTime);

      // Incrementa en 30 minutos
      currentTime = TimeOfDay(
        hour: currentTime.hour,
        minute: currentTime.minute + 30,
      );

      // Ajusta la hora si se excede de 60 minutos
      if (currentTime.minute >= 60) {
        currentTime = TimeOfDay(
          hour: currentTime.hour + 1,
          minute: currentTime.minute - 60,
        );
      }
    }

    return slots;
  }
}
