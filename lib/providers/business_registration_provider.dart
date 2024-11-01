import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final businessRegistrationProvider = StateNotifierProvider<BusinessRegistrationNotifier, BusinessRegistrationState>((ref) {
  return BusinessRegistrationNotifier();
});

class BusinessRegistrationState {
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? phoneError;
  final String? companyError;
  final String? contactNameError;
  final String? addressError;

  BusinessRegistrationState({
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.phoneError,
    this.companyError,
    this.contactNameError,
    this.addressError,
  });
}

class BusinessRegistrationNotifier extends StateNotifier<BusinessRegistrationState> {
  BusinessRegistrationNotifier() : super(BusinessRegistrationState());

  bool validateForm(String email, String password, String confirmPassword, String phone, String companyName, String contactName, String address) {
    // Initialize all error messages to null
    String? companyError;
    String? contactNameError;
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;
    String? phoneError;
    String? addressError;

    bool isValid = true;

    // Validate company name
    if (companyName.isEmpty) {
      companyError = 'Company name is required';
      isValid = false;
    }

    // Validate contact name
    if (contactName.isEmpty) {
      contactNameError = 'Contact name is required';
      isValid = false;
    }

    // Validate address
    if (address.isEmpty) {
      addressError = 'Address is required'; // Add this line
      isValid = false;
    }

    // Validate email
    if (!_isValidEmail(email)) {
      emailError = 'Invalid email';
      isValid = false;
    }

    // Password validation
    if (password.isEmpty) {
      passwordError = 'Password is required';
      isValid = false;
    }

    // Validate passwords match
    if (password != confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
      isValid = false;
    }

    // Validate phone number
    if (phone.isEmpty) {
      phoneError = 'Phone number is required';
      isValid = false;
    }

    // Update state with all error messages at once
    state = BusinessRegistrationState(
      companyError: companyError,
      contactNameError: contactNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      phoneError: phoneError,
      addressError: addressError,
    );

    return isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  
  Future<void> registerBusiness(BuildContext context, String contactEmail, String password, String confirmPassword, String companyName, String contactName, String contactPhone, String address) async {
    final auth = FirebaseAuth.instance;

    try {
      // Register the business account with Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: contactEmail,
        password: password,
      );

      User? user = userCredential.user;

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Save user information to Firestore under 'users' collection
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': contactEmail,
          'companyName': companyName,
          'name': contactName,
          'phoneNumber': contactPhone,
          'address': address,
          'userType': 'business', 
          'createdAt': FieldValue.serverTimestamp(), 
        });
      }

      if (context.mounted) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Created'),
              content: Text(
                'Thank you for creating an account at Dan Gone Wild! An email has been sent to $contactEmail. Please verify the email to activate your account.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();  // Close the dialog
                    Navigator.of(context).pushReplacementNamed('/dashboard');  // Navigate to the dashboard
                  },
                  child: const Text('Go to Dashboard'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        String message = 'Registration failed. Please try again.';
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          message = 'The email address is already in use by another account.';
        }

        // Show error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}