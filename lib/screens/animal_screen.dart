import 'package:dangonewild/providers/animal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../widgets/bug_report_button.dart';

// Logger instance
final logger = Logger();

class AnimalScreen extends ConsumerWidget {
  const AnimalScreen({super.key});

  // Helper function to show animal description and image slideshow in a popup
  void showAnimalDetails(BuildContext context, Animal animal) {
    // Use logger instead of print
    logger.i("Showing details for: ${animal.name}");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(animal.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(animal.description),
                const SizedBox(height: 20),
                // Placeholder for image gallery
                const Text('Image Slideshow Placeholder'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animals = ref.watch(animalsProvider); // Access the list of animals

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet Our Animals'),
        backgroundColor: const Color(0xFF29AB87),  // Jungle Green color from HomeScreen
      ),
      body: Stack(
        children: [
          // Background image covering the full screen
          Positioned.fill(
            child: Image.asset(
              'assets/animal_bg.png',  // Background image for AnimalScreen
              fit: BoxFit.cover,  // Ensure the image covers the entire screen
            ),
          ),
          // Content
          ListView.builder(
            itemCount: animals.length,
            itemBuilder: (context, index) {
              final animal = animals[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Semi-transparent container for text
                    Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent background
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        animal.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for contrast
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ], // Adding shadow for more visibility
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between name and image
                    Image.asset(animal.imageUrls[0], width: 100, height: 100),  // Display the first image as thumbnail
                  ],
                ),
                onTap: () {
                  // Use logger instead of print
                  logger.i("Tapped on: ${animal.name}");
                  showAnimalDetails(context, animal); // Show popup with details
                },
              );
            },
          ),
          BugReportButton(),
        ],
      ),
    );
  }
}
