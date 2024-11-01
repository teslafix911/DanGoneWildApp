// ignore_for_file: library_private_types_in_public_api
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import '../providers/individual_registration_provider.dart';
import '../widgets/jungle_background.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  String firstName = '';  // First Name variable
  String lastName = '';   // Last Name variable
  String email = '';
  String password = '';
  String confirmPassword = '';  // Confirm Password variable
  String phoneNumber = '';  // Phone Number variable

  bool _isPasswordVisible = false;  // Password visibility toggle for password
  bool _isConfirmPasswordVisible = false;  // Password visibility toggle for confirm password

  Future<void> _registerUser() async {
    final individualRegistrationNotifier = ref.read(individualRegistrationProvider.notifier);

    // Validate the form before proceeding
    bool isValid = individualRegistrationNotifier.validateForm(
      firstName, lastName, phoneNumber, email, password, confirmPassword,
    );

    if (!isValid) return; // Stop if validation fails

    final auth = ref.read(authServiceProvider);

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      // Register user and get UserCredential
      UserCredential userCredential = (await auth.signUp(email, password));
      User? user = userCredential.user;  // Extract the User from UserCredential

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Created'),
            content: Text(
              'Thank you for creating an account at Dan Gone Wild! An email has been sent to $email. Please verify the email to activate your account.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  // Close dialog
                  Navigator.of(context).pushReplacementNamed('/home');  // Navigate to home screen
                },
                child: const Text('Go to Home Screen'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    final individualRegistrationState = ref.watch(individualRegistrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.green,
      ),
      body: JungleBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // First Name TextField with Error Handling
              TextField(
                onChanged: (value) => firstName = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.firstNameError,  // Show error if any
                ),
              ),
              const SizedBox(height: 20),

              // Last Name TextField with Error Handling
              TextField(
                onChanged: (value) => lastName = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.lastNameError,  // Show error if any
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number TextField with Error Handling
              TextField(
                onChanged: (value) => phoneNumber = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.phoneNumberError,  // Show error if any
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Email TextField with Error Handling
              TextField(
                onChanged: (value) => email = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.emailError,  // Show error if any
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField with Eye Icon and Error Handling
              TextField(
                onChanged: (value) => password = value,
                style: const TextStyle(color: Colors.white),
                obscureText: !_isPasswordVisible,  // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.passwordError,  // Show error if any
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password TextField with Eye Icon and Error Handling
              TextField(
                onChanged: (value) => confirmPassword = value,
                style: const TextStyle(color: Colors.white),
                obscureText: !_isConfirmPasswordVisible,  // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: individualRegistrationState.confirmPasswordError,  // Show error if any
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import '../providers/individual_registration_provider.dart';
import '../widgets/jungle_background.dart';
import '../widgets/bug_report_button.dart'; // Import BugReportButton

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  String firstName = '';  // First Name variable
  String lastName = '';   // Last Name variable
  String email = '';
  String password = '';
  String confirmPassword = '';  // Confirm Password variable
  String phoneNumber = '';  // Phone Number variable

  bool _isPasswordVisible = false;  // Password visibility toggle for password
  bool _isConfirmPasswordVisible = false;  // Password visibility toggle for confirm password

  Future<void> _registerUser() async {
    final individualRegistrationNotifier = ref.read(individualRegistrationProvider.notifier);

    // Validate the form before proceeding
    bool isValid = individualRegistrationNotifier.validateForm(
      firstName, lastName, phoneNumber, email, password, confirmPassword,
    );

    if (!isValid) return; // Stop if validation fails

    final auth = ref.read(authServiceProvider);

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      // Register user and get UserCredential
      UserCredential userCredential = (await auth.signUp(email, password));
      User? user = userCredential.user;  // Extract the User from UserCredential

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Created'),
            content: Text(
              'Thank you for creating an account at Dan Gone Wild! An email has been sent to $email. Please verify the email to activate your account.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  // Close dialog
                  Navigator.of(context).pushReplacementNamed('/home');  // Navigate to home screen
                },
                child: const Text('Go to Home Screen'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    final individualRegistrationState = ref.watch(individualRegistrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background and registration form content
          JungleBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // First Name TextField with Error Handling
                  TextField(
                    onChanged: (value) => firstName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.firstNameError,  // Show error if any
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Last Name TextField with Error Handling
                  TextField(
                    onChanged: (value) => lastName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.lastNameError,  // Show error if any
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phone Number TextField with Error Handling
                  TextField(
                    onChanged: (value) => phoneNumber = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.phoneNumberError,  // Show error if any
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Email TextField with Error Handling
                  TextField(
                    onChanged: (value) => email = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.emailError,  // Show error if any
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField with Eye Icon and Error Handling
                  TextField(
                    onChanged: (value) => password = value,
                    style: const TextStyle(color: Colors.white),
                    obscureText: !_isPasswordVisible,  // Toggle visibility
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.passwordError,  // Show error if any
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password TextField with Eye Icon and Error Handling
                  TextField(
                    onChanged: (value) => confirmPassword = value,
                    style: const TextStyle(color: Colors.white),
                    obscureText: !_isConfirmPasswordVisible,  // Toggle visibility
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.confirmPasswordError,  // Show error if any
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  ElevatedButton(
                    onPressed: _registerUser,
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
          BugReportButton(),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/individual_registration_provider.dart';
import '../widgets/bug_report_button.dart';
import '../widgets/jungle_background.dart';

class IndividualRegistrationScreen extends ConsumerStatefulWidget {
  const IndividualRegistrationScreen({super.key});

  @override
  _IndividualRegistrationScreenState createState() => _IndividualRegistrationScreenState();
}

class _IndividualRegistrationScreenState extends ConsumerState<IndividualRegistrationScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final individualRegistrationState = ref.watch(individualRegistrationProvider);
    final individualRegistrationNotifier = ref.read(individualRegistrationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Individual Account'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          JungleBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // First Name TextField
                  TextField(
                    onChanged: (value) => firstName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.firstNameError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.firstNameError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Last Name TextField
                  TextField(
                    onChanged: (value) => lastName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.lastNameError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.lastNameError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phone Number TextField
                  TextField(
                    onChanged: (value) => phoneNumber = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.phoneNumberError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.phoneNumberError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Email TextField
                  TextField(
                    onChanged: (value) => email = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.emailError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.emailError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  TextField(
                    onChanged: (value) => password = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.passwordError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password TextField
                  TextField(
                    onChanged: (value) => confirmPassword = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: individualRegistrationState.confirmPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: individualRegistrationState.confirmPasswordError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      bool isValid = individualRegistrationNotifier.validateForm(
                        firstName,
                        lastName,
                        phoneNumber,
                        email,
                        password,
                        confirmPassword,
                      );

                      if (isValid) {
                        individualRegistrationNotifier.registerIndividual(
                          context,
                          email,
                          password,
                        );
                      }
                    },
                    child: const Text('Create Individual Account'),
                  ),
                ],
              ),
            ),
          ),
          BugReportButton(),
        ],
      ),
    );
  }
}
