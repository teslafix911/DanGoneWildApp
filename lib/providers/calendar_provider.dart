import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarState {
  final List<String> unavailableDates;
  final Map<String, List<String>> unavailableTimeSlots;
  final DateTime? selectedDate; 
  final DateTime? currentMonth; 
  final bool isLoading;
  final String? error; 
  final DateTime? showStartTime;

  CalendarState({
    this.unavailableDates = const [],
    this.unavailableTimeSlots = const {},
    this.selectedDate,
    this.currentMonth,
    this.isLoading = false,
    this.error,
    this.showStartTime,
  });

  CalendarState copyWith({
    List<String>? unavailableDates,
    Map<String, List<String>>? unavailableTimeSlots,
    DateTime? selectedDate,
    DateTime? currentMonth,
    bool? isLoading,
    String? error,
    DateTime? showStartTime,
  }) {
    return CalendarState(
      unavailableDates: unavailableDates ?? this.unavailableDates,
      unavailableTimeSlots: unavailableTimeSlots ?? this.unavailableTimeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showStartTime: showStartTime ?? this.showStartTime,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier() : super(CalendarState());

  List<String> generateTimeSlotsForSelectedDate(DateTime selectedDate) {
  List<String> timeSlots = [];
  final DateTime start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 8); // Start at 8:00 AM
  final DateTime end = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 19); // End at 7:00 PM

  for (DateTime time = start; time.isBefore(end) || time == end; time = time.add(const Duration(minutes: 30))) {
    String formattedTime = DateFormat.jm().format(time); // AM/PM format
    timeSlots.add(formattedTime);
  }

  return timeSlots;
}


  // Method to check if a given slot is within the buffer of any event's start time
bool isTimeWithinBuffer(DateTime slotTime, List<DateTime> startTimes) {
  // Iterate over all start times for the selected date
  for (DateTime showStartTime in startTimes) {
    DateTime showEndTime = showStartTime.add(const Duration(hours: 1));

    // Block 2 hours before and 1 hour after the event start time
    DateTime bufferStartTime = showStartTime.subtract(const Duration(hours: 2));
    DateTime bufferEndTime = showEndTime.add(const Duration(hours: 1));

    // Check if the slot falls within the buffer time
    if (slotTime.isAfter(bufferStartTime) && slotTime.isBefore(bufferEndTime)) {
      return true; // Block the time slot
    }
  }

  return false; // Allow the time slot
}

// Method to select a date
  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
    );
  }

  // Add method to update the show start time
  void updateShowStartTime(DateTime newShowStartTime) {
    state = state.copyWith(showStartTime: newShowStartTime); // Update state with the new showStartTime
  }

  // Fetch availability from API
  Future<void> fetchAvailability(DateTime startDate, DateTime endDate) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/checkAvailability'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print('Fetched data: $data');  // Log the fetched data

        // Extract the first start time for the show
        DateTime? showStartTime;
        if (data['unavailableStartTimes'].isNotEmpty) {
          String firstStartTime = data['unavailableStartTimes'].entries.first.value.first;
          showStartTime = DateTime.parse(firstStartTime);
        }

        // Process unavailable start times (previously unavailableTimeSlots)
        state = state.copyWith(
          unavailableDates: List<String>.from(data['unavailableDates']),
          unavailableTimeSlots: Map<String, List<String>>.from(
            data['unavailableStartTimes'].map((key, value) {
              return MapEntry(key, List<String>.from(value));
            })
          ),
          showStartTime: showStartTime, // Update with the correct show start time
          isLoading: false,
        );        
        state = state.copyWith(isLoading: false, error: 'Error fetching data');
              }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Method to fetch availability for the entire month
  Future<void> fetchAvailabilityForMonth(DateTime month) async {

    // Check if the month has already been fetched
    if (month.isAtSameMomentAs(state.currentMonth ?? DateTime(0))) {
      return; // Do not fetch again if it's the same month
    }

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0); // Last day of the month
    await fetchAvailability(startOfMonth, endOfMonth); // Call your fetch logic
    state = state.copyWith(currentMonth: month); // Update the current month
  }
}

// Calendar provider setup
final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});
