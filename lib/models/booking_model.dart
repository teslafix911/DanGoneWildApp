/*
import 'package:flutter/material.dart';

class BookingForm {
  final String? uuid;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<String> selectedAnimals;
  final String eventType;
  final String eventDescription;
  final double? lat;
  final double? lng;
  final List<String> suggestions;  // Add suggestions field

  BookingForm({
    this.uuid,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedAnimals,
    required this.eventType,
    required this.eventDescription,
    this.lat,
    this.lng,
    this.suggestions = const [],  // Default empty list
  });

  // Method to convert TimeOfDay to a string without BuildContext
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${dt.hour}:${dt.minute}";  // You can format this to any preferred time format.
  }

  // Method to convert BookingForm object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,  // Nullable field
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': formatTimeOfDay(selectedTime),  // Format TimeOfDay without BuildContext
      'selectedAnimals': selectedAnimals,
      'eventType': eventType,
      'eventDescription': eventDescription,
      'lat': lat,
      'lng': lng,
    };
  }

  // Method to create a BookingForm object from a Firestore map
  factory BookingForm.fromMap(Map<String, dynamic> map) {
    return BookingForm(
      uuid: map['uuid'],
      name: map['name'],
      address: map['address'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      selectedDate: DateTime.parse(map['selectedDate']),
      selectedTime: TimeOfDay(
        hour: int.parse(map['selectedTime'].split(":")[0]), 
        minute: int.parse(map['selectedTime'].split(":")[1])
      ),
      selectedAnimals: List<String>.from(map['selectedAnimals']),
      eventType: map['eventType'],
      eventDescription: map['eventDescription'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }

  // CopyWith method for immutability
  BookingForm copyWith({
    String? uuid,
    String? name,
    String? address,
    String? email,
    String? phoneNumber,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    List<String>? selectedAnimals,
    String? eventType,
    String? eventDescription,
    double? lat,
    double? lng,
    List<String>? suggestions,  // Include suggestions
  }) {
    return BookingForm(
      uuid: uuid ?? this.uuid,
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
      suggestions: suggestions ?? this.suggestions,  // Update suggestions
    );
  }
}
*/