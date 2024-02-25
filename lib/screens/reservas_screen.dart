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
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                hintText: 'Buscar por nombre de peluquero o datos del cliente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
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
                    _buildFilteredCitasList(_selectedDay!),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildFilteredCitasList(DateTime day) {
    List<String> citas = _events[day] ?? [];

    // Filtrar las citas según el texto de búsqueda
    if (_searchText.isNotEmpty) {
      citas = citas.where((cita) => cita.toLowerCase().contains(_searchText.toLowerCase())).toList();
    }

    if (citas.isEmpty) {
      return Text('No hay citas para este día');
    }

    return Column(
      children: citas.map((cita) => ListTile(title: Text(cita))).toList(),
    );
  }
}