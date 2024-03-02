import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HorarioPeluquerosScreen extends StatelessWidget {
  final String userRole; // New property for user role
  final TimeOfDay morningOpeningTime; // New property for morning opening time
  final TimeOfDay morningClosingTime; // New property for morning closing time
  final TimeOfDay afternoonOpeningTime; // New property for afternoon opening time
  final TimeOfDay afternoonClosingTime; // New property for afternoon closing time
  final List<TimeOfDay> unavailableSlots = [
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 16, minute: 0),
  ];

  final ValueNotifier<DateTime?> selectedDay = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> selectedTime = ValueNotifier(null);

  HorarioPeluquerosScreen({
    required this.userRole,
    required this.morningOpeningTime,
    required this.morningClosingTime,
    required this.afternoonOpeningTime,
    required this.afternoonClosingTime,
  });

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario Peluqueros'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2022, 12, 31),
            focusedDay: DateTime.now().isAfter(DateTime.utc(2022, 12, 31)) 
              ? DateTime.utc(2022, 12, 31) 
              : DateTime.now().isBefore(DateTime.utc(2022, 1, 1)) 
                ? DateTime.utc(2022, 1, 1) 
                : DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
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
      return SizedBox.shrink(); // Empty container
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the grid
        child: GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4, // number of items per row
    childAspectRatio: 3, // Adjust this value to make buttons smaller
    mainAxisSpacing: 8.0, // Add space between each row
    crossAxisSpacing: 8.0, // Add space between each button
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
          selectedTime.value = null; // Set to null if slot is not available
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Make button borders round
          side: BorderSide(color: Colors.black), // Border color
        ),
        color: isSelected ? Colors.black : Colors.white, // Change color based on selection
        child: Container(
          margin: const EdgeInsets.all(4.0), // Add margin around each button
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Add padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time.format(context),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black), // Change text color based on selection
                ),
                Text(
                  isAvailable ? 'Disponible' : 'Bloqueado',
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black), // Change text color based on selection
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
SizedBox(height: 5.0), // Add space between the grid and the button
ValueListenableBuilder<TimeOfDay?>(
  valueListenable: selectedTime,
  builder: (context, value, child) {
    return ElevatedButton(
      onPressed: value != null ? () {
        // Handle button press
      } : null,
      child: Text('Reservar'),
    );
  },
),
        ],
      ),
    );
  }

   int calculateSlotCount() {
    final morningOpeningMinutes = morningOpeningTime.hour * 60 + morningOpeningTime.minute;
    final morningClosingMinutes = morningClosingTime.hour * 60 + morningClosingTime.minute;
    final afternoonOpeningMinutes = afternoonOpeningTime.hour * 60 + afternoonOpeningTime.minute;
    final afternoonClosingMinutes = afternoonClosingTime.hour * 60 + afternoonClosingTime.minute;
    final slotDuration = 30;
    return ((morningClosingMinutes - morningOpeningMinutes) + (afternoonClosingMinutes - afternoonOpeningMinutes)) ~/ slotDuration;
  }

  TimeOfDay calculateTime(int index) {
    final morningOpeningMinutes = morningOpeningTime.hour * 60 + morningOpeningTime.minute;
    final morningClosingMinutes = morningClosingTime.hour * 60 + morningClosingTime.minute;
    final afternoonOpeningMinutes = afternoonOpeningTime.hour * 60 + afternoonOpeningTime.minute;
    final slotDuration = 30;
    final slotMinutes = index * slotDuration;
    final totalMinutes = slotMinutes < (morningClosingMinutes - morningOpeningMinutes) ? morningOpeningMinutes + slotMinutes : afternoonOpeningMinutes + slotMinutes - (morningClosingMinutes - morningOpeningMinutes);
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isSlotAvailable(TimeOfDay time) {
    return !unavailableSlots.contains(time);
  }
}