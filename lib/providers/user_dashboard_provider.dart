import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/booking_provider.dart';
import '../screens/booking_screen.dart';
import '../services/business_account_service.dart';
import 'auth_provider.dart'; 

final bookingsProvider = StreamProvider<List<BookingForm>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value([]);  // No user logged in
  }

  final userUid = user.uid;

  return FirebaseFirestore.instance
      .collection('bookings')
      .where('userId', isEqualTo: userUid)
      .snapshots()
      .map((snapshot) {
        // Convert Firestore documents to BookingForm objects
        final bookings = snapshot.docs.map((doc) => BookingForm.fromMap(doc.data())).toList();

        // Sort bookings by date and time
        bookings.sort((a, b) {
          final dateComparison = a.selectedDate!.compareTo(b.selectedDate!);
          
          if (dateComparison != 0) {
            return dateComparison; // Sort by date if they are different
          } else {
            // Sort by time if the dates are the same
            final timeA = a.selectedTime!;
            final timeB = b.selectedTime!;
            return (timeA.hour * 60 + timeA.minute).compareTo(timeB.hour * 60 + timeB.minute);
          }
        });

        return bookings;
      });
});

// Define the UserDashboardState class
class UserDashboardState {
  final bool isLoading;           
  final String? errorMessage;     

  UserDashboardState({
    this.isLoading = false,
    this.errorMessage,
  });
}

// Create the UserDashboardProvider
final userDashboardProvider = StateNotifierProvider<UserDashboardNotifier, UserDashboardState>((ref) {
  return UserDashboardNotifier(ref);
});

// UserDashboardNotifier to manage user dashboard logic
class UserDashboardNotifier extends StateNotifier<UserDashboardState> {
  UserDashboardNotifier(this.ref) : super(UserDashboardState());

  final Ref ref; // Reference to the provider container

  void navigateToBookingScreen(BuildContext context) async {
    state = UserDashboardState(isLoading: true); // Set loading state

    // Access the user ID from your auth state
    final authState = ref.read(authStateProvider);
    final user = authState.value;

    if (user != null) {
      // Fetch user data using the BusinessAccountService
      final userData = await BusinessAccountService().fetchUserData(user.uid);

      if (userData != null) {
        // Print user data for debugging
        //print('User Data: $userData');

        // Initialize the booking form with user data
        ref.read(bookingFormProvider.notifier).initializeFromUserData(
          userData['name'] ?? 'Unnamed',
          userData['email'] ?? 'No Email Provided',
          userData['phoneNumber'] ?? 'No Phone Number', 
          userData['address'] ?? 'No Address Provided',
        );
  /*
        // Print the initialized booking form for debugging
        print('Booking Form Initialized with:');
        print('Name: ${userData['name'] ?? 'Unnamed'}');
        print('Email: ${userData['email'] ?? 'No Email Provided'}');
        print('Phone: ${userData['phoneNumber'] ?? 'No Phone Number'}');
        print('Address: ${userData['address'] ?? 'No Address Provided'}');
  */
        // Navigate to the BookingScreen
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingScreen()),
          );
        }
      } else {
        state = UserDashboardState(errorMessage: 'No user data found'); // Update error state
        //print('No user data found');
      }
    } else {
      state = UserDashboardState(errorMessage: 'User not logged in'); // Update error state
      //print('User not logged in');
    }

    state = UserDashboardState(isLoading: false); // Reset loading state
  }
}