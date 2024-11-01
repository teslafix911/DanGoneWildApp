import 'package:flutter/material.dart';

class BookingValidation {
  // Validate name
  static bool validateName(String? name) {
    return name != null && name.isNotEmpty;
  }

  // Validate address
  static bool validateAddress(String? address) {
    return address != null && address.isNotEmpty;
  }

  // Validate email
  static bool validateEmail(String? email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return email != null && emailRegex.hasMatch(email);
  }

  // Validate phone number
  static bool validatePhoneNumber(String? phoneNumber) {
    final phoneRegex = RegExp(r'^\+?1?\d{9,15}$');
    return phoneNumber != null && phoneRegex.hasMatch(phoneNumber);
  }

  // Validate selected date
  static bool validateSelectedDate(DateTime? date) {
    return date != null && date.isAfter(DateTime.now());
  }

  // Validate selected time
  static bool validateSelectedTime(TimeOfDay? time) {
    return time != null;
  }

  // Validate selected animals
  static bool validateSelectedAnimals(List<String> animals) {
    return animals.isNotEmpty;
  }

  // Validate event type
  static bool validateEventType(String? eventType) {
    return eventType != null && eventType.isNotEmpty;
  }

  // Validate event description
  static bool validateEventDescription(String? description) {
    return description != null && description.isNotEmpty;
  }
}