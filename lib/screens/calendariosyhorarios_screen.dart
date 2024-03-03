import 'dart:convert';
import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:fl_peluqueria/provider/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
//import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarioYHorarioScreen extends StatefulWidget {
  //const CalendarioYHorarioScreen({Key? key}) : super(key: key);

  @override
  _CalendarioYHorarioScreenState createState() =>
      _CalendarioYHorarioScreenState();
}

class _CalendarioYHorarioScreenState extends State<CalendarioYHorarioScreen> {
  String? userRole;
  late UsuarioRoleProvider userRoleProvider;
  final String databaseURL =
      'https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app/';

  /*  
   Future<void> insertData(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$databaseURL/horarios.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Datos insertados correctamente');
      } else {
        print('Error al insertar datos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al insertar datos: $error');
    }
  }
 */
  Future<void> updateData(String horarioId, Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$databaseURL/horarios/$horarioId.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Datos actualizados correctamente');
      } else {
        print('Error al actualizar datos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al actualizar datos: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool _isFirstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      userRoleProvider = Provider.of<UsuarioRoleProvider>(context);

      String? rol = userRoleProvider.user?.rol;
      if (rol != 'gerente') {
        // Muestra un mensaje de error y redirige al usuario después de que el proceso de construcción se haya completado
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Necesario rol "gerente".')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      }
      _isFirstTime = false;
    }
  }

  //fechas seleccionadas en el calendario
  var _diaInicio;
  var _diaFin;
  //horarios  seleccionados en el reloj
  var horaAperturaManana;
  var horaCierreManana;
  var horaAperturaTarde;
  var horaCierreTarde;
  //formato de las fechas seleccionadas
  String? diaInicioFormat;
  String? diaFinFormat;
  //booleano para los sabados activados o desactivados
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    List<DateTime> blackoutDates = <DateTime>[];

    // Añade los días festivos a la lista
    blackoutDates.addAll([
      DateTime(DateTime.now().year, 1, 1), // Año Nuevo
      DateTime(DateTime.now().year, 1, 6), // Epifanía
      DateTime(DateTime.now().year, 4, 19), // Viernes Santo
      DateTime(DateTime.now().year, 5, 1), // Día del Trabajador
      DateTime(DateTime.now().year, 10, 12), // Fiesta Nacional de España
      DateTime(DateTime.now().year, 11, 1), // Día de Todos los Santos
      DateTime(DateTime.now().year, 12, 6), // Día de la Constitución
      DateTime(DateTime.now().year, 12, 8), // Día de la Inmaculada Concepción
      DateTime(DateTime.now().year, 12, 25), // Navidad
    ]);

    // Añade los sábados a la lista
    for (int year = DateTime.now().year;
        year <= DateTime.now().year + 1;
        year++) {
      for (int month = 1; month <= 12; month++) {
        for (int day = 1; day <= DateTime(year, month + 1, 0).day; day++) {
          DateTime date = DateTime(year, month, day);
          if (date.weekday == DateTime.saturday) {
            blackoutDates.add(date);
          }
        }
      }
    }

    //horarios
    Future<TimeOfDay?> getTimePickerWidget() {
      return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: ThemeData.dark(),
          child: child!,
        ),
      );
    }

    void callTimePicker(Function(TimeOfDay) timeSetter) async {
      var selectedTime = await getTimePickerWidget();
      if (selectedTime != null) {
        if (selectedTime.hour < 9 ||
            selectedTime.hour > 22 ||
            (selectedTime.minute != 0 && selectedTime.minute != 30)) {
          // La hora seleccionada está fuera del rango permitido
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Por favor, selecciona una hora entre las 9:00 y las 20:30 en rangos de 30 minutos')),
          );
        } else {
          // La hora seleccionada está dentro del rango permitido
          setState(() {
            timeSetter(selectedTime);
          });
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendario y horarios'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Activar/Desactivar Sabados'),
                    Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                height: 322.0,
                color: Colors.grey.shade300,
                child: SfDateRangePicker(
                  key: ValueKey(_switchValue),
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  cellBuilder: cellBuilder,
                  selectionColor: Colors.amber,
                  startRangeSelectionColor: Colors.grey,
                  endRangeSelectionColor: Colors.grey,
                  rangeSelectionColor: Colors.grey.shade100,
                  selectionMode: DateRangePickerSelectionMode.range,
                  //blackoutDates: blackoutDates,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    setState(() {
                      PickerDateRange range = args.value;
                      _diaInicio = range.startDate.toString();
                      diaInicioFormat = _diaInicio.substring(0, 10);
                      _diaFin = range.endDate.toString();
                      diaFinFormat = _diaFin.substring(0, 10);
                      //_selectedRange = PickerDateRange(startDate, endDate);
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Fecha de inicio: ${diaInicioFormat ?? 'No seleccionada'}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Fecha de fin: ${diaFinFormat ?? 'No seleccionada'}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        callTimePicker((time) => horaAperturaManana = time),
                    child: Text('Apertura mañanas'),
                  ),
                  Text(
                    '${horaAperturaManana?.format(context) ?? 'No seleccionada'}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        callTimePicker((time) => horaCierreManana = time),
                    child: Text('Cierre mañanas'),
                  ),
                  Text(
                    '${horaCierreManana?.format(context) ?? 'No seleccionada'}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        callTimePicker((time) => horaAperturaTarde = time),
                    child: Text('Apertura tardes'),
                  ),
                  Text(
                    '${horaAperturaTarde?.format(context) ?? 'No seleccionada'}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        callTimePicker((time) => horaCierreTarde = time),
                    child: Text('Cierre tardes'),
                  ),
                  Text(
                    '${horaCierreTarde?.format(context) ?? 'No seleccionada'}',
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmación'),
                  content: const Text(
                      '¿Estás seguro de que quieres actualizar los horarios de la peluquería?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () async {
                        Navigator.of(context).pop();

                        // Obtener el rol del usuario del proveedor
                        String? userRole = Provider.of<UsuarioRoleProvider>(
                                context,
                                listen: false)
                            .user
                            ?.rol;

                        // Verificar si el rol del usuario es 'gerente'

                        updateData('hor001', {
                          'AperMan': horaAperturaManana.format(context),
                          'AperTar': horaAperturaTarde.format(context),
                          'CieMan': horaCierreManana.format(context),
                          'CieTar': horaCierreTarde.format(context),
                          'fechaFin': diaInicioFormat,
                          'fechaInicio': diaFinFormat,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Los horarios han sido actualizados.')),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 540,
          child: const Icon(Icons.add),
        ));
  }

  @override
  Widget cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
    DateTime _visibleDates = details.date;
    if (isSpecialDate(_visibleDates)) {
      return IgnorePointer(
        ignoring: true, // Hace que los eventos de interacción sean ignorados
        child: Container(
          color: Colors.red,
          child: Column(
            children: [
              Text(
                details.date.day.toString(),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.red.shade600,
                height: 5,
              ),
              const Icon(
                Icons.close_sharp,
                size: 13,
                color: Colors.black,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Text(
          details.date.day.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  bool isSpecialDate(DateTime date) {
    List<DateTime> specialDates = [
      // List of national holidays in Spain
      DateTime(DateTime.now().year, 1, 1), // New Year's Day
      DateTime(DateTime.now().year, 1, 6), // Epiphany
      DateTime(DateTime.now().year, 4, 19), // Good Friday
      DateTime(DateTime.now().year, 5, 1), // Labor Day
      DateTime(DateTime.now().year, 10, 12), // National Day of Spain
      DateTime(DateTime.now().year, 11, 1), // All Saints' Day
      DateTime(DateTime.now().year, 12, 6), // Constitution Day
      DateTime(DateTime.now().year, 12, 8), // Immaculate Conception
      DateTime(DateTime.now().year, 12, 25), // Christmas Day
    ];
    for (int j = 0; j < specialDates.length; j++) {
      if ((date.year == specialDates[j].year &&
              date.month == specialDates[j].month &&
              date.day == specialDates[j].day) ||
          (_switchValue && date.weekday == DateTime.saturday) ||
          date.weekday == DateTime.sunday) {
        return true;
      }
    }
    return false;
  }
}
