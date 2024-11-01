
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

// Create a logger instance
final logger = Logger();

// Payment state model
class PaymentState {
  final bool isPaymentSuccessful;
  final String? errorMessage;
  final bool isLoading; 

  PaymentState({
    required this.isPaymentSuccessful,
    this.errorMessage,
    this.isLoading = false,
  });

  factory PaymentState.success() {
    return PaymentState(isPaymentSuccessful: true, errorMessage: null);
  }

  factory PaymentState.failure(String errorMessage) {
    return PaymentState(isPaymentSuccessful: false, errorMessage: errorMessage);
  }
}

// Payment provider state
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier();
});

// StateNotifier for managing the payment process
class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState(isPaymentSuccessful: false));

  // Method to set loading state
  void setLoading(bool loading) {
    state = PaymentState(
      isPaymentSuccessful: state.isPaymentSuccessful,
      errorMessage: state.errorMessage,
      isLoading: loading,
    );
  }

  // Check if the current payment state is loading
  bool get isLoading => state.isLoading;

  // Function to format the date with ordinal suffix
  String formatDateWithOrdinal(DateTime date) {
    final String formattedDate = DateFormat("MMMM d").format(date);
    final String daySuffix = _getOrdinalSuffix(date.day);
    return '$formattedDate$daySuffix'; // Example: "September 26th"
  }

  // Helper function to get the ordinal suffix like 'st', 'nd', 'rd', 'th'
  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Method to simulate payment processing and add booking to Firestore
  Future<void> processPayment({
    required BuildContext context,
    required String firstName,
    required DateTime date,
    required TimeOfDay time,
    required List<String> animals,
    required String location,
    required String eventType,
    required String eventDescription,
    required String email,
    required String phoneNumber,
  }) async {
    // Set loading state
    setLoading(true);
    //print('Loading started...');

    try {
      // Simulate a mock payment processing
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay

      // Get the current user’s UUID if logged in
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid; // Get userId if logged in, otherwise null for guest

      // Check if the widget is still mounted before using context
      if (context.mounted) {
        // Call Firestore to add booking details after payment is successful
        await FirebaseFirestore.instance.collection('bookings').add({
          'userId': userId, // Store UUID or null for guest users
          'name': firstName,
          'selectedDate': date.toIso8601String(),
          'selectedTime': time.format(context),
          'selectedAnimals': animals,
          'location': location,
          'eventType': eventType,
          'eventDescription': eventDescription,
          'email': email, 
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Log that booking was added successfully
        logger.i("Booking added to Firestore successfully");

        // Show a success message or navigate to a success screen
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful and booking confirmed!')),
          );
        }
      }
    } catch (e) {
      // Log the error and set payment state to failure
      logger.e('Payment failed: $e');
      state = PaymentState.failure('Payment failed, please try again.');
      
      // Show error message if context is still mounted
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    } finally {
      // Reset loading state after processing
      setLoading(false);
    }
  }
}