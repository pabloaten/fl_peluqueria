import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarioYHorarioScreen extends StatefulWidget {
  const CalendarioYHorarioScreen({Key? key}) : super(key: key);

  @override
  _CalendarioYHorarioScreenState createState() =>
      _CalendarioYHorarioScreenState();
}

class _CalendarioYHorarioScreenState extends State<CalendarioYHorarioScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement the build method
    List<DateTime> nationalHolidays = [
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
    var dateRange;
    TimeOfDay? _horaSeleccionada;
    Future<void> _selectTime(BuildContext context) async {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        if (selectedTime.hour < 9 ||
            selectedTime.hour > 20 ||
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
            selectedTime = _horaSeleccionada;
          });
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendario y Horario'),
          backgroundColor: Colors.grey.shade400,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              height: 400.0,
              color: Colors.grey.shade300,
              child: SfDateRangePicker(
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                cellBuilder: cellBuilder,
                selectionColor: Colors.amber,
                startRangeSelectionColor: Colors.grey,
                endRangeSelectionColor: Colors.grey,
                rangeSelectionColor: Colors.grey.shade100,
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                cancelText: "Cancelar",
                confirmText: "Aceptar",
                onSubmit: (dateRange) {
                  print(dateRange);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // agrega espacio en la parte superior
              child: ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Seleccionar hora de apertura:'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0), // agrega espacio en la parte superior
              child: Text(
                  'Hora Apertura: ${_horaSeleccionada?.format(context) ?? 'No seleccionada'}'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // agrega espacio en la parte superior
              child: ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Seleccionar hora de Cierre:'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0), // agrega espacio en la parte superior
              child: Text(
                  'Hora Cierre: ${_horaSeleccionada?.format(context) ?? 'No seleccionada'}'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO logica para guardar la fecha seleccionada y la hora!
          },
          backgroundColor: Colors.blueGrey.shade100,
          elevation: 15,
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
          date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        return true;
      }
    }
    return false;
  }
}
