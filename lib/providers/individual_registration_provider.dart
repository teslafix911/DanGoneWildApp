import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final individualRegistrationProvider = StateNotifierProvider<IndividualRegistrationNotifier, IndividualRegistrationState>((ref) {
  return IndividualRegistrationNotifier();
});

class IndividualRegistrationState {
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? firstNameError;
  final String? lastNameError;
  final String? phoneNumberError;

  IndividualRegistrationState({
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.firstNameError,
    this.lastNameError,
    this.phoneNumberError,
  });
}

class IndividualRegistrationNotifier extends StateNotifier<IndividualRegistrationState> {
  IndividualRegistrationNotifier() : super(IndividualRegistrationState());

  bool validateForm(String firstName, String lastName, String phoneNumber, String email, String password, String confirmPassword) {
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;
    String? firstNameError;
    String? lastNameError;
    String? phoneNumberError;

    bool isValid = true;

    // First name validation
    if (firstName.isEmpty) {
      firstNameError = 'First name is required';
      isValid = false;
    }

    // Last name validation
    if (lastName.isEmpty) {
      lastNameError = 'Last name is required';
      isValid = false;
    }

    // Phone number validation
    if (phoneNumber.isEmpty) {
      phoneNumberError = 'Phone number is required';
      isValid = false;
    }

    // Email validation
    if (!_isValidEmail(email)) {
      emailError = 'Invalid email';
      isValid = false;
    }

    // Password validation
    if (password.isEmpty) {
      passwordError = 'Password is required';
      isValid = false;
    }

    // Confirm password validation
    if (password != confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
      isValid = false;
    }

    // Update the state with the errors
    state = IndividualRegistrationState(
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      phoneNumberError: phoneNumberError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );

    return isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  // Method to register individual user and show success popup
  Future<void> registerIndividual(BuildContext context, String email, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      // Register the individual account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (context.mounted) {
        // Show the success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Created'),
              content: Text(
                'Thank you for creating an individual account at Dan Gone Wild! An email has been sent to $email. Please verify the email to activate your account.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();  
                    Navigator.of(context).pushReplacementNamed('/dashboard');  
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
