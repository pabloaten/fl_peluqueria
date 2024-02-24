import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservasScreen extends StatefulWidget {
  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {
    DateTime.now(): ['Cita 1', 'Cita 2'], // Ejemplo de citas para el día actual
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(_focusedDay.year, _focusedDay.month, 1),
            lastDay: DateTime.utc(_focusedDay.year, _focusedDay.month + 1, 0),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          SizedBox(height: 20),
          _selectedDay != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Citas para el día ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildCitasList(_selectedDay!),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCitasList(DateTime day) {
    List<String> citas = _events[day] ?? [];

    if (citas.isEmpty) {
      return Text('No hay citas para este día');
    }

    return Column(
      children: citas.map((cita) => ListTile(title: Text(cita))).toList(),
    );
  }
}
