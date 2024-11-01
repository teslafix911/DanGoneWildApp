import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dangonewild/providers/about_provider.dart';

import '../widgets/bug_report_button.dart'; // Import the provider

class AboutMeScreen extends ConsumerWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutText = ref.watch(aboutProvider); // Watch the provider for the about text
    final images = ref.watch(aboutImagesProvider); // Watch provider for the images list

    // Get full screen size using MediaQuery
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dan Gone Wild'),
        backgroundColor: const Color(0xFF29AB87),  // Jungle Green color
      ),
      body: Stack(
        children: [
          // Background image covering the full screen
          SizedBox(
            height: size.height,  // Set the height to full screen
            width: size.width,    // Set the width to full screen
            child: Image.asset(
              'assets/aboutme_bg.png',
              fit: BoxFit.cover,  // Ensure the image covers the entire screen
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),  // Black overlay with 50% opacity
            ),
          ),
          // Content on top of the background and overlay
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daniel Marks' biography
                  const Text(
                    'About Dan Gone Wild',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for better contrast
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3, 3),
                        ),
                      ],  // Adding shadow to make text stand out
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    aboutText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text for better contrast
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],  // Adding shadow to make text stand out
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Placeholder for slideshow
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for better contrast
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3, 3),
                        ),
                      ],  // Adding shadow to make text stand out
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: images.length, // Dynamic number of images
                      itemBuilder: (context, index) {
                        return Image.asset(
                          images[index], // Load images from the provider
                          fit: BoxFit.cover,
                        );
                      },
                    ),
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

