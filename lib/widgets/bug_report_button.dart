import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/report_button_provider.dart';
/*
class BugReportButton extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  BugReportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(reportButtonProvider);

    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, // White background for readability
          borderRadius: BorderRadius.circular(8), // Rounded corners for aesthetic
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3), // Subtle shadow for depth
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            ref.read(reportButtonProvider.notifier).onPressed(); // Toggle button state

            // Show popup dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Report an Issue"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Your Email (optional)'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Describe the issue'),
                        maxLines: 4,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog without submitting
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Call the submitBug function in the provider
                        await ref.read(reportButtonProvider.notifier).submitBug(
                          emailController.text,
                          descriptionController.text,
                        );

                        // After submission, safely check if the context is still mounted
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Close the dialog after submission
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ],
                );
              },
            );
          },
          child: isLoading
              ? const CircularProgressIndicator()  // Show a loading indicator while submitting
              : const Text(
                  'Report an Issue',
                  style: TextStyle(
                    color: Colors.redAccent,  // Customize the text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}*/
/*
class BugReportButton extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  BugReportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(reportButtonProvider);

    return Positioned(
      bottom: 20, // Moves the button to the bottom
      right: 20,  // Right-aligned
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            ref.read(reportButtonProvider.notifier).onPressed();

            // Show bug report dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Report an Issue"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Your Email (optional)',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10), // Add spacing between inputs
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Describe the issue',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 4,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (descriptionController.text.isEmpty) {
                          // Ensure the description is not empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please describe the issue')),
                          );
                          return;
                        }

                        await ref.read(reportButtonProvider.notifier).submitBug(
                          emailController.text,
                          descriptionController.text,
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator() // Loading indicator
                          : const Text('Submit'),
                    ),
                  ],
                );
              },
            );
          },
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Report an Issue',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}*/

class BugReportButton extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  BugReportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(reportButtonProvider);

    return Positioned(
      bottom: 20, // Moves the button to the bottom
      right: 20,  // Right-aligned
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            ref.read(reportButtonProvider.notifier).onPressed();

            // Show bug report dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Feedback"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Your Email (optional)',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10), // Add spacing between inputs
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Feedback',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 4,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Reset the loading state when cancelling
                        ref.read(reportButtonProvider.notifier).resetLoading();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (descriptionController.text.isEmpty) {
                          // Ensure the description is not empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please provide feeback')),
                          );
                          return;
                        }

                        await ref.read(reportButtonProvider.notifier).submitBug(
                          emailController.text,
                          descriptionController.text,
                        );

                        // After submission, reset the loading state and close the dialog
                        ref.read(reportButtonProvider.notifier).resetLoading();

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator() 
                          : const Text('Submit'),
                    ),
                  ],
                );
              },
            ).then((_) {
              // Ensure the loading state is reset when the dialog is closed
              ref.read(reportButtonProvider.notifier).resetLoading();
            });
          },
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

