import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/calendar_provider.dart';

class TimeSlotSelectorWidget extends ConsumerWidget {
  final Function(String) onTimeSelected;
  final DateTime showStartTime; 

  const TimeSlotSelectorWidget({
    super.key,
    required this.onTimeSelected,
    required this.showStartTime, 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);

    String? selectedDateString = calendarState.selectedDate?.toIso8601String().split('T')[0];

    // If no date is selected, prompt the user to select a date
    if (selectedDateString == null) {
      return const Text('Please select a date first.');
    }

    DateTime selectedDate = DateTime.parse(selectedDateString);

    // Generate time slots for the selected date
    final timeSlots = ref.read(calendarProvider.notifier).generateTimeSlotsForSelectedDate(selectedDate);

    return SizedBox( 
      width: 400,
      height: 800,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if the screen is wide (desktop) or narrow (mobile)
          bool isWideScreen = constraints.maxWidth > 600;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Select a Time Slot',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timeSlots.map((timeSlot) {
                      DateTime slotTime = convertToDateTimeFromString(timeSlot, selectedDateString);

                      // Fetch the list of start times for the selected date (check for null)
                      List<DateTime> startTimes = calendarState.unavailableTimeSlots[selectedDateString]
                          ?.map((startTimeString) => DateTime.parse(startTimeString))
                          .toList() ?? [];

                      // Check if the time slot is within the buffer of any event's start time
                      bool isWithinBuffer = startTimes.any((startTime) {
                        return ref.read(calendarProvider.notifier).isTimeWithinBuffer(slotTime, startTimes);
                      });

                      return SizedBox(
                        width: isWideScreen ? constraints.maxWidth * 0.2 : constraints.maxWidth * 0.4, 
                        child: ChoiceChip(
                          label: Text(timeSlot),
                          selected: false,
                          onSelected: isWithinBuffer ? null : (selected) {
                            onTimeSelected(timeSlot); 
                          },
                          selectedColor: isWithinBuffer ? Colors.grey : Theme.of(context).primaryColor,
                          backgroundColor: isWithinBuffer ? Colors.grey.shade300 : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // Helper function to convert the timeSlot string into a DateTime object
  DateTime convertToDateTimeFromString(String timeSlot, String selectedDateString) {
    DateTime date = DateTime.parse(selectedDateString);
    DateTime parsedTime = DateFormat.jm().parse(timeSlot); // Parse "8:30 AM" as time

    // Return a DateTime object with the same date but the parsed time
    return DateTime(date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
  }
}