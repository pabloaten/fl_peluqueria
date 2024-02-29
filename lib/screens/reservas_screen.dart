import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_peluqueria/models/reservas.dart';
import 'package:fl_peluqueria/services/reservas_services.dart';

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

  // Instancia del servicio de reservas
  final ReservasServices _reservasService = ReservasServices();

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
          ),
          SizedBox(height: 20),
          _selectedDay != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Citas para el día ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Llamada al método para construir la lista de citas filtrada por la fecha seleccionada
                    _buildFilteredCitasList(_selectedDay!),
                  ],
                )
              : SizedBox(),
          SizedBox(height: 20),
          // Mostrar reservas al final de la pantalla
          Expanded(
            child: Consumer<ReservasServices>(
              builder: (context, reservasProvider, _) {
                final List<Reservas> reservas = reservasProvider.reservas;

                // Filtra las reservas por la fecha seleccionada
                final List<Reservas> reservasEnFechaSeleccionada = reservas
                
                    .where((reserva) =>
                        reserva.fecha != null &&
                        isSameDay(DateTime.parse(reserva.fecha[0]) ,_selectedDay))
                    .toList();

                return ListView.builder(
                  itemCount: reservasEnFechaSeleccionada.length,
                  itemBuilder: (context, index) {
                    final reserva = reservasEnFechaSeleccionada[index];
                    return ListTile(
                      title: Text('A'),
                      subtitle: Text(reserva.fecha?.toString() ?? ''),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilteredCitasList(DateTime day) {
    // Aquí puedes definir cómo se construye la lista de citas filtradas
    if (_selectedDay != null) {
      // Aquí puedes definir cómo se construye la lista de citas filtradas
      return Container(); // Por ejemplo, puedes devolver un contenedor vacío si no necesitas mostrar citas filtradas
    } else {
      return SizedBox(); // Retorna un contenedor vacío si _selectedDay es nulo
    }
  }
}
