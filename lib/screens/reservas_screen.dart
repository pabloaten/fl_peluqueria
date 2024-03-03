import 'package:fl_peluqueria/app_theme/app_theme.dart';
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
      /*  appBar: AppBar(
        title: Text('Reservas'),
      ), */
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
                hintText: 'Buscar por nombre de peluquero, cliente o servicio',
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
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    AppTheme.primary, // Aquí puedes definir el color que desees
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(134, 105, 99, 99), // Color del día de hoy
              ),
              selectedTextStyle: TextStyle(
                  color: Colors
                      .white), // Color del texto dentro del día seleccionado
            ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                // Filtrar las citas por nombre del peluquero, cliente o servicio
                final List<Reservas> reservasFiltered = _searchText.isEmpty
                    ? reservas
                        .where((reserva) =>
                            reserva.fecha != null &&
                            isSameDay(
                                DateTime.parse(reserva.fecha[0]), _selectedDay))
                        .toList()
                    : reservas.where((reserva) {
                        final peluquero =
                            reserva.peluquero.toString().toLowerCase();
                        final cliente =
                            reserva.usuario.toString().toLowerCase();
                        final servicios =
                            reserva.servicios.join(',').toLowerCase();
                        return peluquero.contains(_searchText.toLowerCase()) ||
                            cliente.contains(_searchText.toLowerCase()) ||
                            servicios.contains(_searchText.toLowerCase());
                      }).toList();

                return ListView.builder(
                  itemCount: reservasFiltered.length,
                  itemBuilder: (context, index) {
                    final reserva = reservasFiltered[index];
                    return ListTile(
                      title: Text(
                        'Cita Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(reserva.fecha!.first))}',
                      ),
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
              Text(
                  'Fecha y Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(reserva.fecha!.first))}'),
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
