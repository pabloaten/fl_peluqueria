import 'dart:convert';
import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:fl_peluqueria/provider/user_role_provider.dart';

class HorarioPeluquerosScreen extends StatefulWidget {
  @override
  _HorarioPeluquerosScreenState createState() =>
      _HorarioPeluquerosScreenState();
}

class _HorarioPeluquerosScreenState extends State<HorarioPeluquerosScreen> {
  late TimeOfDay morningOpeningTime;
  late TimeOfDay morningClosingTime;
  late TimeOfDay tardeOpeningTime;
  late TimeOfDay tardeClosingTime;
  late UsuarioRoleProvider userRoleProvider;
  bool _isButtonSelected = false;

  final String databaseURL =
      'https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app/';
  bool isLoading = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime? _focusedDay;
  bool _isDaySelected = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = _selectedDay;
    obtenerHorarioDesdeBD(
        'hor001'); // Suponiendo que el horario del peluquero se guarda con el ID 'hor001'
  }

  bool _isFirstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      userRoleProvider = Provider.of<UsuarioRoleProvider>(context);

      String? rol = userRoleProvider.user?.rol;
      if (rol != 'peluquero') {
        // Muestra un mensaje de error y redirige al usuario después de que el proceso de construcción se haya completado
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Necesario rol "peluquero".')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      }
      _isFirstTime = false;
    }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay!,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return day.weekday != DateTime.sunday;
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _isDaySelected =
                          true; // Actualiza el estado cuando se selecciona un día
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppTheme
                          .primary, // Aquí puedes usar tu color primario
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(
                          134, 105, 99, 99), // Color del día de hoy
                    ),
                  ),
                ),
                Divider(), // Divider
                if (_isDaySelected &&
                    morningOpeningTime != null &&
                    morningClosingTime != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.primary, // Color de fondo negro
                            ),
                            onPressed: () {
                              // Handle button press
                            },
                            child: Text('${time.hour}:${time.minute}'),
                          );
                        },
                      ),
                    ),
                  ),
                Divider(), // Divider
                if (_isDaySelected &&
                    tardeOpeningTime != null &&
                    tardeClosingTime != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: calculateTimeSlots(
                                tardeOpeningTime, tardeClosingTime)
                            .length,
                        itemBuilder: (context, index) {
                          final time = calculateTimeSlots(
                              tardeOpeningTime, tardeClosingTime)[index];
                          return ElevatedButton(
                             style: ElevatedButton.styleFrom(
                              primary: AppTheme.primary, // Color de fondo negro
                            ),
                            onPressed: () {
                              // Handle button press
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

      // Increment by 30 minutes
      currentTime = TimeOfDay(
        hour: currentTime.hour,
        minute: currentTime.minute + 30,
      );

      // Adjust the hour if exceeds 60 minutes
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
