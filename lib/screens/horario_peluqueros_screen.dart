import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HorarioPeluquerosScreen extends StatelessWidget {
  final TimeOfDay openingTime = TimeOfDay(hour: 9, minute: 0);
  final TimeOfDay closingTime = TimeOfDay(hour: 18, minute: 0);
  final List<TimeOfDay> unavailableSlots = [
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 16, minute: 0),
  ];

  final ValueNotifier<DateTime?> selectedDay = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
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
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // number of items per row
                  ),
                  itemCount: calculateSlotCount(),
                  itemBuilder: (context, index) {
                    final time = calculateTime(index);
                    final isAvailable = isSlotAvailable(time);
                    return GridTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(time.format(context)),
                          isAvailable ? ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            child: Text('Reservar'),
                          ) : Text('Bloqueado'),
                        ],
                      ),
                    );
                  },
                ),
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
}