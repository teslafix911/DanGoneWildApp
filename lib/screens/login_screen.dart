// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/bug_report_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String email = '';
  String password = '';

  Future<void> _signInUser() async {
    final auth = ref.read(authServiceProvider);

    try {
      await auth.signIn(email, password);

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Method to show the dialog with Business and Individual options
  void _showAccountTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please select which type of account describes you'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Business Account'),
                subtitle: const Text('Register as a business to manage company events and bookings.'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushNamed('/business-register'); // Navigate to business registration
                },
              ),
              ListTile(
                title: const Text('Individual Account'),
                subtitle: const Text('Register as an individual for personal use of our services.'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushNamed('/register'); // Navigate to individual registration
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF29AB87), // Jungle Green
      ),
      body: Stack(
        children: [
          // Background image covering the full screen
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/jungle_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay to improve text visibility
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1), // Adds space at the top
                TextField(
                  style: const TextStyle(color: Colors.white), // White text color for better contrast
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0), // Brighter underline
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0), // Brighter underline
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(color: Colors.white), // White text color for better contrast
                  onChanged: (value) => password = value,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0), // Brighter underline
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0), // Brighter underline
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C00), // Deep Orange
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: _signInUser,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _showAccountTypeDialog, // Call the dialog function here
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color(0xFFFFD700), // Warm Yellow
                      fontSize: 16.0, // Increase font size for better readability
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: Color(0xFFFFD700), // Warm Yellow
                      fontSize: 16.0, // Increase font size for better readability
                    ),
                  ),
                ),
                const Spacer(flex: 1), // Adds space at the bottom
              ],
            ),
          ),
          BugReportButton(),
        ],
      ),
    );
  }
}

