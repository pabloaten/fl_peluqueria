import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



class ReservasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario de Reservas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReservationCalendarScreen(),
    );
  }
}

class ReservationCalendarScreen extends StatefulWidget {
  @override
  _ReservationCalendarScreenState createState() => _ReservationCalendarScreenState();
}

class _ReservationCalendarScreenState extends State<ReservationCalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Reservas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(_focusedDay.year, _focusedDay.month, 1), // Establecer el primer día del mes actual
              lastDay: DateTime.utc(_focusedDay.year, _focusedDay.month + 1, 0), // Establecer el último día del mes actual
              focusedDay: _focusedDay,
              // Aquí puedes personalizar el aspecto del calendario según tus necesidades
            ),
            SizedBox(height: 20),
            // Aquí podrías mostrar las reservas del día seleccionado en el calendario
            // Por ejemplo, podrías listar las reservas en forma de lista debajo del calendario
            // Puedes obtener las reservas de tu base de datos o de donde las almacenes
            // y mostrarlas de acuerdo a la fecha seleccionada en el calendario
            // También puedes implementar acciones como agregar, editar o eliminar reservas.
          ],
        ),
      ),
    );
  }
}
