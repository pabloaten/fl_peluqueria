import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarioYHorarioScreen extends StatelessWidget {
  const CalendarioYHorarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DateTime> nationalHolidays = [
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
      DateTime(DateTime.saturday),
      DateTime(DateTime.sunday),
    ];
    var dateRange;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendario y Horario'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey.shade200,
            child: SfDateRangePicker(
              monthViewSettings:
                  //DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  DateRangePickerMonthViewSettings(
                      specialDates: nationalHolidays),
              cellBuilder: cellBuilder,
              selectionColor: Colors.amber,
              startRangeSelectionColor: Colors.grey,
              endRangeSelectionColor: Colors.grey,
              rangeSelectionColor: Colors.grey.shade100,
              //Modo de selección de fecha o rango de fechas
              selectionMode: DateRangePickerSelectionMode.range,
              showActionButtons: true,
              //Texto de los botones de aceptar y cancelar
              cancelText: "Cancelar",
              confirmText: "Aceptar",
              //recoger fecha o rango de fechas establecido.
              onSubmit: (dateRange) {
                print(dateRange);
              },
            ),
          ),
        ));
  }

  Widget cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
    DateTime _visibleDates = details.date;
    if (isSpecialDate(_visibleDates)) {
      return Column(
        children: [
          Container(
            child: Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            color: Colors.red.shade600,
            height: 5,
          ),
          Icon(
            Icons.celebration,
            size: 13,
            color: Colors.red,
          ),
        ],
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
      if (date.year == specialDates[j].year &&
              date.month == specialDates[j].month &&
              date.day == specialDates[j].day ||
          date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        return true;
      }
    }
    return false;
  }
}
