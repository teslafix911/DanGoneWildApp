import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calendar_provider.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(DateTime)? fetchAvailabilityForMonth;

  const CalendarWidget({
    super.key,
    required this.onDateSelected,
    this.fetchAvailabilityForMonth,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  bool _hasFetchedData = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch availability when the widget is first loaded, if not already fetched
    if (!_hasFetchedData) {
      final DateTime now = DateTime.now();
      ref.read(calendarProvider.notifier).fetchAvailabilityForMonth(now);
      _hasFetchedData = true; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarProvider);

    // Show a CircularProgressIndicator when loading
    if (calendarState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(), 
      );
    }

    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime(2100),
      focusedDay: calendarState.currentMonth ?? DateTime.now(),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      
      onDaySelected: (selectedDay, focusedDay) {
        final dayString = selectedDay.toIso8601String().split('T')[0];

        // Check if the selected day is unavailable
        if (!calendarState.unavailableDates.contains(dayString)) {
          Future.microtask(() {
            if (context.mounted) {
              ref.read(calendarProvider.notifier).selectDate(selectedDay);
              widget.onDateSelected(selectedDay); 
              Navigator.pop(context); 
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected date is unavailable')),
          );
        }
      },
      
      onPageChanged: (focusedDay) {
        ref.read(calendarProvider.notifier).fetchAvailabilityForMonth(focusedDay);
      },
      
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final dayString = day.toIso8601String().split('T')[0];

          // Check if the day is in unavailable dates OR has no available time slots.
          if (calendarState.unavailableDates.contains(dayString) ||
              (calendarState.unavailableTimeSlots.containsKey(dayString) &&
               calendarState.unavailableTimeSlots[dayString]!.isEmpty)) {
            return Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.grey), // Grey out unavailable dates
              ),
            );
          }

          // Check if the date has unavailable start times for specific events (to apply the buffer logic).
          if (calendarState.unavailableTimeSlots.containsKey(dayString)) {
            final unavailableStartTimes = calendarState.unavailableTimeSlots[dayString]!;

            // If unavailable start times are found for the day, apply buffer logic
            if (unavailableStartTimes.isNotEmpty) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.black), 
                ),
              );
            }
          }
          return null; // Default behavior for available dates
        },
      ),
    );
  }
}

