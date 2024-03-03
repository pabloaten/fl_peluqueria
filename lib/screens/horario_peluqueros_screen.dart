import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// Importa la clase de CalendarioYHorarioScreen
import 'package:fl_peluqueria/models/usuario.dart';

class HorarioPeluquerosScreen extends StatefulWidget {
  @override
  _HorarioPeluquerosScreenState createState() =>
      _HorarioPeluquerosScreenState();
}

class _HorarioPeluquerosScreenState extends State<HorarioPeluquerosScreen> {
  late String userRole = 'peluquero'; // Variable para almacenar el rol del usuario
  late TimeOfDay morningOpeningTime; // Variables para horarios de apertura
  late TimeOfDay morningClosingTime; // Variables para horarios de cierre
  late TimeOfDay afternoonOpeningTime; // Variables para horarios de apertura
  late TimeOfDay afternoonClosingTime; // Variables para horarios de cierre
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
    ];// Lista de días festivos

  ValueNotifier<DateTime?> selectedDay = ValueNotifier<DateTime?>(null);
  ValueNotifier<TimeOfDay?> selectedTime = ValueNotifier<TimeOfDay?>(null);
  TimeOfDay openingTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay closingTime = TimeOfDay(hour: 20, minute: 0);
  List<TimeOfDay> unavailableSlots = [];

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los datos del usuario y horarios
    loadUserData();
  }

  // Función para cargar los datos del usuario y horarios
  void loadUserData() async {
    // Obtiene el usuario actual
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtiene el rol del usuario
      String? role = await getUserRole(user.uid);
      // Obtiene los horarios de la peluquería
      getTimeSlotsFromDatabase();
      setState(() {
        userRole = role ?? ''; // Almacena el rol del usuario
      });
    }
  }

  // Función para obtener el rol del usuario desde la base de datos
  Future<String?> getUserRole(String userId) async {
    Usuario usuario = await obtenerUsuarioDesdeBD(userId);
    return usuario.rol;
  }

  //Consulta a la base de datos para obtener el usuario
  Future<Usuario> obtenerUsuarioDesdeBD(String userId) async {
    try {
      // Realiza la consulta a Firestore para obtener los datos del usuario
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      // Verifica si el usuario existe
      if (userSnapshot.exists) {
        // Crea una instancia del usuario con los datos obtenidos de Firestore
        Usuario usuario =
            Usuario.fromMap(userSnapshot.data() as Map<String, dynamic>);
        return usuario;
      } else {
        // Si el usuario no existe, puedes manejar el caso aquí, por ejemplo, lanzando una excepción o devolviendo un usuario por defecto.
        throw Exception(
            'El usuario con ID $userId no fue encontrado en la base de datos.');
      }
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir durante la consulta
      print('Error al obtener usuario desde la base de datos: $e');
      rethrow; // Lanza el error nuevamente para que pueda ser manejado en el lugar donde se llama a esta función
    }
  }

  void getTimeSlotsFromDatabase() async {
    try {
      // Realiza la consulta a Firestore para obtener los horarios de apertura y cierre
      DocumentSnapshot horariosSnapshot = await FirebaseFirestore.instance
          .collection('horarios')
          .doc('peluqueria')
          .get();

      if (horariosSnapshot.exists) {
        // Obtiene los datos de los horarios de Firestore
        Map<String, dynamic> data =
            horariosSnapshot.data() as Map<String, dynamic>;
        setState(() {
          // Asigna los horarios obtenidos a las variables correspondientes
          morningOpeningTime =
              TimeOfDay.fromDateTime(data['morning_opening_time'].toDate());
          morningClosingTime =
              TimeOfDay.fromDateTime(data['morning_closing_time'].toDate());
          afternoonOpeningTime =
              TimeOfDay.fromDateTime(data['afternoon_opening_time'].toDate());
          afternoonClosingTime =
              TimeOfDay.fromDateTime(data['afternoon_closing_time'].toDate());

          // Actualiza las variables openingTime y closingTime
          openingTime = morningOpeningTime;
          closingTime = afternoonClosingTime;

          // Calcula unavailableSlots
          unavailableSlots.clear();
          unavailableSlots.addAll([
            // Aquí puedes agregar cualquier intervalo de tiempo no disponible según tus necesidades
            // Por ejemplo, si hay un intervalo de almuerzo que no está disponible, puedes agregarlo aquí.
            // Solo asegúrate de que los intervalos de tiempo no disponibles se encuentren en unavailableSlots
          ]);
        });
      } else {
        // Si los horarios no existen en la base de datos, puedes manejar el caso aquí
        print('No se encontraron horarios en la base de datos.');
      }
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir durante la consulta
      print('Error al obtener los horarios desde la base de datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica el rol del usuario y muestra la pantalla correspondiente
    if (userRole != 'peluquero') {
      return Scaffold(
        appBar: AppBar(
          title: Text('No autorizado'),
        ),
        body: Center(
          child: Text('Solo los peluqueros pueden acceder a esta pantalla.'),
        ),
      );
    }
    // Si el usuario es peluquero, muestra la pantalla de horarios
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario Peluqueros'),
      ),
      body: Column(
        children: [
          // según corresponda para configurar el calendario
          TableCalendar(
  firstDay: DateTime.utc(2022, 1, 1),
  lastDay: DateTime.utc(2022, 12, 31),
  focusedDay: DateTime.now().isAfter(DateTime.utc(2022, 12, 31))
      ? DateTime.utc(2022, 12, 31)
      : DateTime.now().isBefore(DateTime.utc(2022, 1, 1))
          ? DateTime.utc(2022, 1, 1)
          : DateTime.now(),
  selectedDayPredicate: (day) =>
      isSameDay(selectedDay.value, day),
  enabledDayPredicate: (day) {
    // Deshabilita los domingos y los días festivos
    return day.weekday != DateTime.sunday && !isHoliday(day);
  },
  onDaySelected: (selectedDay, focusedDay) {
    if (isSameDay(this.selectedDay.value, selectedDay)) {
      this.selectedDay.value = null;
    } else {
      this.selectedDay.value = selectedDay;
    }
  },
  calendarStyle: CalendarStyle(
    selectedDecoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
  ),
),

          ValueListenableBuilder<DateTime?>(
            valueListenable: selectedDay,
            builder: (context, value, child) {
              if (value == null) {
                return SizedBox
                    .shrink(); // Empty container
              }
              return Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Add padding around the grid
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          4, // number of items per row
                      childAspectRatio:
                          3, // Adjust this value to make buttons smaller
                      mainAxisSpacing: 8.0, // Add space between each row
                      crossAxisSpacing:
                          8.0, // Add space between each button
                    ),
                    itemCount: calculateSlotCount(),
                    itemBuilder: (context, index) {
                      final time = calculateTime(index);
                      final isAvailable = isSlotAvailable(time);
                      final isSelected = selectedTime.value == time;
                      return GestureDetector(
                        onTap: () {
                          if (isAvailable) {
                            selectedTime.value = time;
                          } else {
                            selectedTime.value =
                                null; // Set to null if slot is not available
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make button borders round
                            side: BorderSide(
                                color: Colors
                                    .black), // Border color
                          ),
                          color: isSelected
                              ? Colors.black
                              : Colors.white, // Change color based on selection
                          child: Container(
                            margin: const EdgeInsets.all(
                                4.0), // Add margin around each button
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Add padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    time.format(context),
                                    style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors
                                                .black), // Change text color based on selection
                                  ),
                                  Text(
                                    isAvailable
                                        ? 'Disponible'
                                        : 'Bloqueado',
                                    style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors
                                                .black), // Change text color based on selection
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(
              height:
                  5.0), // Add space between the grid and the button
          ValueListenableBuilder<TimeOfDay?>(
            valueListenable: selectedTime,
            builder: (context, value, child) {
              return ElevatedButton(
                onPressed: value != null
                    ? () {
                        // Handle button press
                      }
                    : null,
                child: Text('Reservar'),
              );
            },
          ),
        ],
      ),
    );
  }

  int calculateSlotCount() {
    final openingMinutes = openingTime.hour * 60 + openingTime.minute;
    final closingMinutes = closingTime.hour * 60 + closingTime.minute;
    final slotDuration = 30;
    return (closingMinutes - openingMinutes) ~/ slotDuration;
  }

  TimeOfDay calculateTime(int index) {
    final openingMinutes = openingTime.hour * 60 + openingTime.minute;
    final slotDuration = 30;
    final slotMinutes = index * slotDuration;
    final totalMinutes = openingMinutes + slotMinutes;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isSlotAvailable(TimeOfDay time) {
    return !unavailableSlots.contains(time);
  }

 bool isHoliday(DateTime day) {
  // Verifica si el día proporcionado está en la lista de días festivos
  return nationalHolidays.contains(DateTime(day.year, day.month, day.day));
}

}
