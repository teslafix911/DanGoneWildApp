
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportButtonNotifier extends StateNotifier<bool> {
  ReportButtonNotifier() : super(false);

  // Function to handle when the button is pressed (toggle button state)
  void onPressed() {
    state = !state; 
  }

  // Function to reset the loading state
  void resetLoading() {
    state = false; 
  }

  // Function to submit the bug report to Firestore
  Future<void> submitBug(String email, String description) async {
    try {
      // Set state to true to indicate loading
      state = true;

      // Add the bug report to Firestore
      await FirebaseFirestore.instance.collection('supportTickets').add({
        'userId': 'anonymous', 
        'email': email.isNotEmpty ? email : 'Anonymous',
        'description': description, 
        'timestamp': FieldValue.serverTimestamp(), 
        'status': 'open', 
        'priority': 'medium', 
        'comments': [], 
      });

      // Set state to false after successful submission
      state = false;
    } catch (e) {
      // Handle errors here
      state = false; 
      //print("Error submitting bug: $e");
      // Optionally show a message to the user about the error
      rethrow; 
    }
  }
}

// Create the provider for the report button
final reportButtonProvider = StateNotifierProvider<ReportButtonNotifier, bool>((ref) {
  return ReportButtonNotifier();
});
