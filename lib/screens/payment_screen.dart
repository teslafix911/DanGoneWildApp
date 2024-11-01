import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/payment_provider.dart';
import '../widgets/bug_report_button.dart';
import '../widgets/pine_forest_background.dart';

class PaymentScreen extends ConsumerWidget {
  final String firstName;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<String> selectedAnimals;
  final String location;
  final String eventType;
  final String eventDescription;
  final String email;
  final String phoneNumber;

  const PaymentScreen({super.key, 
    required this.firstName,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedAnimals,
    required this.location,
    required this.eventType,
    required this.eventDescription,
    required this.email, 
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentNotifier = ref.watch(paymentProvider.notifier);
    final formattedDate = paymentNotifier.formatDateWithOrdinal(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background and main content
          PineForestBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm Payment for $firstName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Display the selected details for review
                    const Text(
                      'Event Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Event Type: $eventType',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Event Description: $eventDescription',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Time: ${selectedTime.format(context)}',
                      style: const TextStyle(color: Colors.white), 
                    ),
                    Text(
                      'Location: $location',
                      style: const TextStyle(color: Colors.white), 
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Selected Animals:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    for (var animal in selectedAnimals) 
                      Text(
                        '- $animal',
                        style: const TextStyle(color: Colors.white), 
                      ),
                    const SizedBox(height: 20),

                    // Confirm Payment Button
                    ElevatedButton(
                      onPressed: () async {

                        // Set loading state
                        paymentNotifier.setLoading(true); // Set loading to true
                        //print('Loading started...'); // Print statement to indicate spinner start

                        // Call the processPayment method with the provided details
                        try {
                          await paymentNotifier.processPayment(
                            context: context,
                            firstName: firstName,
                            date: selectedDate,
                            time: selectedTime,
                            animals: selectedAnimals,
                            location: location,
                            eventType: eventType,
                            eventDescription: eventDescription,
                            email: email,
                            phoneNumber: phoneNumber,
                          );

                          // Show dialog after successful payment
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Payment Successful'),
                                  content: Text('Thank you for booking with Dan Gone Wild! A confirmation email has been sent to $email.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Navigate back to the home screen
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      },
                                      child: const Text('Home'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (error) {
                          // Handle any errors that occur during payment processing
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('An error occurred: $error')),
                            );
                          }
                        } finally {
                          // Clear loading state
                          paymentNotifier.setLoading(false); // Set loading to false
                          //print('Loading stopped.');
                        }
                      },
                      child: ref.watch(paymentProvider).isLoading  
                          ? const Row( 
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(width: 8), 
                              Text('Processing...'), 
                            ],
                          )
                          : const Text('Confirm Payment'),
                    )
                  ],
                ),
              ),
            ),
          ),
          BugReportButton(),
        ],
      ),
    );
  }
}

