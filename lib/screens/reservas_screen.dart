import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
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
                      'Citas para el día ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildFilteredCitasList(_selectedDay!),
                  ],
                )
              : Container(),
          SizedBox(height: 20),
          Expanded(
            child: Consumer<ReservasServices>(
              builder: (context, reservasProvider, _) {
                final List<Reservas> reservas = reservasProvider.reservas;

                final List<Reservas> reservasEnFechaSeleccionada = reservas
                    .where((reserva) =>
                        reserva.fecha != null &&
                        isSameDay(
                            DateTime.parse(reserva.fecha[0]), _selectedDay))
                    .toList();

                return ListView.builder(
                  itemCount: reservasEnFechaSeleccionada.length,
                  itemBuilder: (context, index) {
                    final reserva = reservasEnFechaSeleccionada[index];
                    return ListTile(
                      title: Text(
                          'Cita Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(reserva.fecha!.first))}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showReservaDetails(context, reserva);
                        },
                        child: Text('Detalles'),
                      ),
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
    if (_selectedDay != null) {
      return Container();
    } else {
      return SizedBox();
    }
  }

  void _showReservaDetails(BuildContext context, Reservas reserva) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Reserva'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Fecha y Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(reserva.fecha!.first))}'),
              Text('Cancelada: ${reserva.cancelada ? 'Sí' : 'No'}'),
              Text('Pagada: ${reserva.pagada ? 'Sí' : 'No'}'),
              Text('Peluquero: ${reserva.peluquero}'),
              Text('Cliente: ${reserva.usuario}'),
              Text('Servicios: ${reserva.servicios.skip(1).join(', ')}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
