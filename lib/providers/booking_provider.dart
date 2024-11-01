import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';  
import '../screens/booking_confirmation_screen.dart';
import '../utils/booking_validation.dart';

// Logger instance
final logger = Logger();

// Operator's location for distance calculation
const operatorLatitude = 28.451988101712825; 
const operatorLongitude = -81.35313737022665; 
const maxDistance = 25.0; // 25 miles radius limit 

class BookingForm {
  String? name;
  String? address;
  String? email;
  String? phoneNumber;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedAnimals;
  String? eventType;
  String? eventDescription;
  double? lat;
  double? lng;
  DateTime? createdAt;

  // Track validation states
  bool nameValid;
  bool addressValid;
  bool emailValid;
  bool phoneNumberValid;
  bool selectedDateValid;
  bool selectedTimeValid;
  bool selectedAnimalsValid;
  bool eventTypeValid;
  bool eventDescriptionValid;
  bool isWithinServiceArea;

  // Add unavailable dates and unavailable time slots to the state
  final List<String> unavailableDates;
  final Map<String, List<String>> unavailableTimeSlots;
  final bool isLoading;
  final List<String> suggestions;

  BookingForm({
    this.name,
    this.address,
    this.email,
    this.phoneNumber,
    this.selectedDate,
    this.selectedTime,
    this.selectedAnimals = const [],
    this.eventType,
    this.eventDescription,
    this.nameValid = true,
    this.addressValid = true,
    this.emailValid = true,
    this.phoneNumberValid = true,
    this.selectedDateValid = true,
    this.selectedTimeValid = true,
    this.selectedAnimalsValid = true,
    this.eventTypeValid = true,
    this.eventDescriptionValid = true,
    this.lat,
    this.lng,
    this.isWithinServiceArea = true,
    this.unavailableDates = const [],
    this.unavailableTimeSlots = const {},
    this.isLoading = false,
    this.suggestions = const [],
    this.createdAt,
  });

  // Define copyWith for immutability
  BookingForm copyWith({
    String? name,
    String? address,
    String? email,
    String? phoneNumber,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    List<String>? selectedAnimals,
    String? eventType,
    String? eventDescription,
    bool? nameValid,
    bool? addressValid,
    bool? emailValid,
    bool? phoneNumberValid,
    bool? selectedDateValid,
    bool? selectedTimeValid,
    bool? selectedAnimalsValid,
    bool? eventTypeValid,
    bool? eventDescriptionValid,
    double? lat,
    double? lng,
    bool? isWithinServiceArea,
    List<String>? unavailableDates,
    Map<String, List<String>>? unavailableTimeSlots,
    bool? isLoading,
    List<String>? suggestions,
  }) {
    return BookingForm(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedAnimals: selectedAnimals ?? this.selectedAnimals,
      eventType: eventType ?? this.eventType,
      eventDescription: eventDescription ?? this.eventDescription,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isWithinServiceArea: isWithinServiceArea ?? this.isWithinServiceArea,
      nameValid: nameValid ?? this.nameValid,
      addressValid: addressValid ?? this.addressValid,
      emailValid: emailValid ?? this.emailValid,
      phoneNumberValid: phoneNumberValid ?? this.phoneNumberValid,
      selectedDateValid: selectedDateValid ?? this.selectedDateValid,
      selectedTimeValid: selectedTimeValid ?? this.selectedTimeValid,
      selectedAnimalsValid: selectedAnimalsValid ?? this.selectedAnimalsValid,
      eventTypeValid: eventTypeValid ?? this.eventTypeValid,
      eventDescriptionValid: eventDescriptionValid ?? this.eventDescriptionValid,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      unavailableTimeSlots: unavailableTimeSlots ?? this.unavailableTimeSlots,
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  // Static method to convert a time string to TimeOfDay
  static TimeOfDay convertToTimeOfDay(String timeString) {
  try {
    // Normalize the time string to remove any unusual characters and ensure 'P' and 'M' are standard
    String cleanedTimeString = timeString
        .replaceAll(RegExp(r'[^\x00-\x7F]'), '') // Remove non-ASCII characters
        .replaceAll('\u00A0', ' ') // Replace non-breaking space with a regular space
        .replaceAll(' ', ' ') // Replace any narrow no-break space with regular space
        .replaceAll(RegExp(r'[Pp][Mm]'), 'PM') // Ensure standard 'PM'
        .replaceAll(RegExp(r'[Aa][Mm]'), 'AM') // Ensure standard 'AM')
        .trim();

    //print('Cleaned Time String: $cleanedTimeString');

    // Extract the time part
    final timeParts = cleanedTimeString.split(' ');

    if (timeParts.length != 2) {
      throw const FormatException('Invalid time format');
    }

    final time = timeParts[0];
    final period = timeParts[1].toUpperCase(); // AM/PM

    // Split time into hour and minute
    final timeComponents = time.split(':');
    if (timeComponents.length != 2) {
      throw const FormatException('Invalid time format');
    }

    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Adjust hour for PM (add 12 to convert to 24-hour format)
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0; // Midnight case
    }

    //print('Parsed Time: Hour: $hour, Minute: $minute');
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    //print('Error parsing time: $e');
    return const TimeOfDay(hour: 0, minute: 0);  // Default value on error
  }
}

  // Method to create a BookingForm object from a Firestore map
  factory BookingForm.fromMap(Map<String, dynamic> map) {
    return BookingForm(
      name: map['name'],
      address: map['location'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      selectedDate: DateTime.parse(map['selectedDate']),
      selectedTime: BookingForm.convertToTimeOfDay(map['selectedTime']),
      selectedAnimals: List<String>.from(map['selectedAnimals']),
      eventType: map['eventType'],
      eventDescription: map['eventDescription'],
      lat: map['lat'],
      lng: map['lng'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert BookingForm object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'selectedDate': selectedDate?.toIso8601String(),
      'selectedTime': formatTimeOfDay(selectedTime!),
      'selectedAnimals': selectedAnimals,
      'eventType': eventType,
      'eventDescription': eventDescription,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }
  // FormatTimeOfDay method
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}

// Booking form provider
final bookingFormProvider = StateNotifierProvider<BookingFormNotifier, BookingForm>((ref) {
  return BookingFormNotifier();
});

class BookingFormNotifier extends StateNotifier<BookingForm> {
  BookingFormNotifier() : super(BookingForm());

  // Method to set the loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  final List<String> animals = [
    'Alligator/Caimen',
    'Rhino Iguana',
    'Day Geckos',
    'Tarantula',
    'False Water Cobra',
    'Ball Python',
    'Scorpion',
  ];

  // Centralized list of event types
  final List<String> eventTypes = [
    'Birthday Party', 
    'Corporate Event', 
    'Resort/Hotel Show', 
    'Private Party', 
    'Educational Show', 
    'Other'
  ];

  // Getter to expose the event types list
  List<String> getEventTypes() {
    return eventTypes;
  }

  // Fetch address suggestions from the AddressService
  Future<void> getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      state = state.copyWith(suggestions: []); // Clear suggestions if input is empty
      return;
    }

    try {
      final response = await http.get(Uri.parse(
        'https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/getPlaceSuggestions?input=$input',
      ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(
          suggestions: List<String>.from(data.map((item) => item['description'])),
        );
      } else {
        state = state.copyWith(suggestions: []);
      }
    } catch (e) {
      state = state.copyWith(suggestions: []);
    }
  }

  // Method to update the selected address in the booking form!!!!!
  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void initializeFromUserData(String name, String email, String phoneNumber, String address) {
    //print('Initializing Booking Form with: Name: $name, Email: $email, Phone: $phoneNumber, Address: $address');
    state = state.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  // Method to update the latitude and longitude
  void updateLatLng(double lat, double lng) {
    // Update the state with the new latitude and longitude
    state = state.copyWith(
      lat: lat,
      lng: lng,
    );

    // Immediately check if the selected address is within the allowed radius
    bool isInServiceArea = isWithinRadius(lat, lng);

    // Update the state with the service area check result
    state = state.copyWith(isWithinServiceArea: isInServiceArea);

    // Print for debugging
    //print('Lat: $lat, Lng: $lng, Is within service area: $isInServiceArea');
  }

  // Function to calculate the distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarthMiles = 3958.8; // Radius of the Earth in miles
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarthMiles * c; // Distance in miles

    // Print the calculated distance for logging
    //print('Calculated distance: $distance miles');
    return distance;
  }

  // Check if the selected location is within the allowed radius
  bool isWithinRadius(double selectedLat, double selectedLon) {
    double distance = calculateDistance(
      operatorLatitude, 
      operatorLongitude, 
      selectedLat, 
      selectedLon
    );

    // Print the distance and radius check
    //print('Distance from operator: $distance miles');
    //print('Max allowed distance: $maxDistance miles');
    
    return distance <= maxDistance;
  }

  // Helper function to convert degrees to radians
  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  // Method to fetch availability from Firebase Function
  Future<void> fetchAvailability(DateTime startDate, DateTime endDate) async {
    final url = Uri.parse('https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/checkAvailability');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'startDate': DateFormat('yyyy-MM-dd').format(startDate),
          'endDate': DateFormat('yyyy-MM-dd').format(endDate),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Convert List<dynamic> to List<String> explicitly
        final unavailableTimeSlots = Map<String, List<String>>.from(
          data['unavailableTimeSlots'].map((key, value) => MapEntry(key, List<String>.from(value)))
        );
        final unavailableDates = List<String>.from(data['unavailableDates']);

        // Update state
        state = state.copyWith(
          unavailableTimeSlots: unavailableTimeSlots,
          unavailableDates: unavailableDates,
        );

        logger.i('Availability fetched successfully');
      } else {
        logger.e('Failed to fetch availability. Status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (error) {
      logger.e('Error fetching availability: $error');
    } 
  }

// Generate a list of times in 15-minute increments from 8:00 AM to 7:00 PM
List<String> generateTimeSlots() {
  List<String> timeSlots = [];
  DateTime startTime = DateTime(0, 1, 1, 8, 0); // Start time: 8:00 AM
  DateTime endTime = DateTime(0, 1, 1, 19, 0);  // End time: 7:00 PM

  while (startTime.isBefore(endTime) || startTime == endTime) {
    timeSlots.add(DateFormat.jm().format(startTime)); // Format in 12-hour AM/PM
    startTime = startTime.add(const Duration(minutes: 15));
  }

  return timeSlots;
}

  // Method to check availability for a specific date and time
  Future<bool> checkAvailabilityForDateAndTime(BuildContext context, DateTime selectedDate, TimeOfDay selectedTime) async {
    final url = Uri.parse('https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/checkSpecificAvailability');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'selectedDate': DateFormat('yyyy-MM-dd').format(selectedDate),
          'selectedTime': selectedTime.format(context), 
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isAvailable']; 
      } else {
        logger.e('Failed to check specific availability. Status code: ${response.statusCode}, body: ${response.body}');
        return false;
      }
    } catch (error) {
      logger.e('Error checking specific availability: $error');
      return false;
    }
  }

  Future<void> proceedToConfirmation(BuildContext context, WidgetRef ref) async {
  // Set loading state
  ref.read(bookingFormProvider.notifier).setLoading(true); 

  // Get the current selected date and time from the provider
  final bookingForm = ref.read(bookingFormProvider);

  // Check if selectedDate and selectedTime are not null
  if (bookingForm.selectedDate != null && bookingForm.selectedTime != null) {
    // Fetch availability for the specific date and time
    final isAvailable = await checkAvailabilityForDateAndTime(
      context, 
      bookingForm.selectedDate!, 
      bookingForm.selectedTime!,
    );

    // Check if the widget is still mounted before interacting with context
    if (!context.mounted) {
      ref.read(bookingFormProvider.notifier).setLoading(false); 
      return;
    }

    if (isAvailable) {
      // Proceed to the confirmation page using Riverpod for state management
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingConfirmationPage(),
        ),
      );
    } else {
      // Show an error if the selected date/time is unavailable
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The selected date or time is unavailable. Please choose a different slot.'),
        ),
      );
    }
  } else {
    // Handle the case where date or time is not selected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select both a date and time before proceeding.'),
      ),
    );
  }

  // Reset loading state after processing
  ref.read(bookingFormProvider.notifier).setLoading(false); 
}

// Convert a 12-hour AM/PM formatted time to TimeOfDay
TimeOfDay convertToTimeOfDay(String slot) {
  final parsedTime = DateFormat.jm().parse(slot); 
  return TimeOfDay(
    hour: parsedTime.hour,
    minute: parsedTime.minute,
  );
}

  // Method to show event type selection modal
  void showEventTypeSelectionModal(BuildContext context) {
    final eventTypes = getEventTypes(); 
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: eventTypes.length,
            itemBuilder: (context, index) {
              final eventType = eventTypes[index];
              return ListTile(
                title: Text(eventType),
                onTap: () {
                  updateEventType(eventType); 
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected Event Type: $eventType')),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void showEventDescriptionEditModal(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: state.eventDescription);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Event Description'),
          content: TextField(
            controller: controller,
            maxLines: null, 
            decoration: const InputDecoration(
              hintText: 'Enter event description',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  updateEventDescription(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Update methods for each field
  void updateName(String name) {
    state = state.copyWith(name: name);
  }
  
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: time);
  }

  void updateEventType(String eventType) {
    state = state.copyWith(eventType: eventType);
  }

  void updateEventDescription(String eventDescription) {
    state = state.copyWith(eventDescription: eventDescription);
  }

  void selectAnimal(String animal) {  
    if (!state.selectedAnimals.contains(animal)) {
      state = state.copyWith(
        selectedAnimals: [...state.selectedAnimals, animal],
      );
    }
  }

  void deselectAnimal(String animal) {  
    state = state.copyWith(
      selectedAnimals: state.selectedAnimals.where((a) => a != animal).toList(),
    );
  }

  // Validation for required fields
  bool validateBookingForm() {
  final nameValid = BookingValidation.validateName(state.name);
  final addressValid = BookingValidation.validateAddress(state.address);
  final emailValid = BookingValidation.validateEmail(state.email);
  final phoneNumberValid = BookingValidation.validatePhoneNumber(state.phoneNumber);
  final selectedDateValid = BookingValidation.validateSelectedDate(state.selectedDate);
  final selectedTimeValid = BookingValidation.validateSelectedTime(state.selectedTime);
  final selectedAnimalsValid = BookingValidation.validateSelectedAnimals(state.selectedAnimals);
  final eventTypeValid = BookingValidation.validateEventType(state.eventType);
  final eventDescriptionValid = BookingValidation.validateEventDescription(state.eventDescription);

  // Update state with validation results
  state = state.copyWith(
    nameValid: nameValid,
    addressValid: addressValid,
    emailValid: emailValid,
    phoneNumberValid: phoneNumberValid,
    selectedDateValid: selectedDateValid,
    selectedTimeValid: selectedTimeValid,
    selectedAnimalsValid: selectedAnimalsValid,
    eventTypeValid: eventTypeValid,
    eventDescriptionValid: eventDescriptionValid,
  );

  // Combine all validation results
  return nameValid && addressValid && emailValid && phoneNumberValid && selectedDateValid && selectedTimeValid && selectedAnimalsValid && eventTypeValid && eventDescriptionValid;
}

  // FormatTimeOfDay method
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}