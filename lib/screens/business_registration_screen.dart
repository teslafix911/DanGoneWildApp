/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/business_registration_provider.dart';
import '../widgets/bug_report_button.dart';
import '../widgets/jungle_background.dart';

class BusinessRegistrationScreen extends ConsumerStatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusinessRegistrationScreenState createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends ConsumerState<BusinessRegistrationScreen> {
  String companyName = '';
  String contactName = '';
  String contactEmail = '';
  String contactPhone = '';
  String password = '';
  String confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final businessRegistrationState = ref.watch(businessRegistrationProvider);
    final businessRegistrationNotifier = ref.read(businessRegistrationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Business Account'),
        backgroundColor: Colors.green,
      ),
      body: JungleBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Company Name TextField
              TextField(
                onChanged: (value) => companyName = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.companyError,  // Error handling for company name
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: businessRegistrationState.companyError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Point of Contact Name TextField
              TextField(
                onChanged: (value) => contactName = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Point of Contact Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.contactNameError,  // Error handling for contact name
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: businessRegistrationState.contactNameError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Point of Contact Email TextField with Error Handling
              TextField(
                onChanged: (value) => contactEmail = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Point of Contact Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.emailError,  // Show email error if any
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: businessRegistrationState.emailError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Point of Contact Phone TextField with Error Handling
              TextField(
                onChanged: (value) => contactPhone = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Point of Contact Phone',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.phoneError,  // Show phone error if any
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: businessRegistrationState.phoneError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Password TextField with Error Handling
              TextField(
                onChanged: (value) => password = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.passwordError,  // Show password error if any
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
                      color: businessRegistrationState.passwordError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 20),

              // Confirm Password TextField with Error Handling
              TextField(
                onChanged: (value) => confirmPassword = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: businessRegistrationState.confirmPasswordError,  // Show confirm password error if any
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
                      color: businessRegistrationState.confirmPasswordError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
              ),
              const SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  bool isValid = businessRegistrationNotifier.validateForm(
                    contactEmail,
                    password,
                    confirmPassword,
                    contactPhone,
                    companyName,
                    contactName,
                  );
                  
                  if (isValid) {
                    businessRegistrationNotifier.registerBusiness(
                      context,
                      contactEmail,
                      password,
                      confirmPassword,
                    );
                  }
                },
                child: const Text('Create Business Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/business_registration_provider.dart';
import '../widgets/bug_report_button.dart';  // Import BugReportButton
import '../widgets/jungle_background.dart';

class BusinessRegistrationScreen extends ConsumerStatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusinessRegistrationScreenState createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends ConsumerState<BusinessRegistrationScreen> {
  String companyName = '';
  String contactName = '';
  String address = '';
  String contactEmail = '';
  String contactPhone = '';
  String password = '';
  String confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final businessRegistrationState = ref.watch(businessRegistrationProvider);
    final businessRegistrationNotifier = ref.read(businessRegistrationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Business Account'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background and form content
          JungleBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Company Name TextField
                  TextField(
                    onChanged: (value) => companyName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.companyError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: businessRegistrationState.companyError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Point of Contact Name TextField
                  TextField(
                    onChanged: (value) => contactName = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Point of Contact Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.contactNameError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: businessRegistrationState.contactNameError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add Address TextField with Error Handling
                  TextField(
                    onChanged: (value) => address = value, // Add a new variable to hold the address
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Business Address',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.addressError, // Error handling for the address
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: businessRegistrationState.addressError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Point of Contact Email TextField with Error Handling
                  TextField(
                    onChanged: (value) => contactEmail = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Point of Contact Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.emailError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: businessRegistrationState.emailError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Point of Contact Phone TextField with Error Handling
                  TextField(
                    onChanged: (value) => contactPhone = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Point of Contact Phone',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.phoneError,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: businessRegistrationState.phoneError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Password TextField with Error Handling
                  TextField(
                    onChanged: (value) => password = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.passwordError,
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
                          color: businessRegistrationState.passwordError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password TextField with Error Handling
                  TextField(
                    onChanged: (value) => confirmPassword = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: businessRegistrationState.confirmPasswordError,
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
                          color: businessRegistrationState.confirmPasswordError != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      bool isValid = businessRegistrationNotifier.validateForm(
                        contactEmail,
                        password,
                        confirmPassword,
                        contactPhone,
                        companyName,
                        contactName,
                        address,
                      );
                      
                      if (isValid) {
                        businessRegistrationNotifier.registerBusiness(
                          context,
                          contactEmail,
                          password,
                          confirmPassword,
                          companyName,
                          contactName,
                          contactPhone,
                          address,
                        );
                      }
                    },
                    child: const Text('Create Business Account'),
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
