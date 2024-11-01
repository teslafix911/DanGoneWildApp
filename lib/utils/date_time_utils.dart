import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

// Initialize timezone data (call this at app startup)
void initializeTimezones() {
  tzData.initializeTimeZones(); // Ensure timezone data is loaded
}

// Utility function to format DateTime into Eastern Time (ET)
String formatToEasternTime(DateTime dateTime) {
  // Get the America/New_York timezone for Eastern Time (ET)
  final easternTimeZone = tz.getLocation('America/New_York');
  
  // Convert the provided DateTime to ET, accounting for daylight savings
  final easternTime = tz.TZDateTime.from(dateTime, easternTimeZone);

  // Format the time in a readable format (e.g., Oct 31, 2024 4:00 PM)
  return DateFormat.yMMMd().add_jm().format(easternTime);
}

// Function to format TimeOfDay to a readable string
String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.jm().format(dt); // E.g., "4:00 PM"
}
