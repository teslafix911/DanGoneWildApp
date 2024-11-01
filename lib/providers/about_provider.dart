import 'package:flutter_riverpod/flutter_riverpod.dart';

// About Daniel Marks text
final aboutProvider = Provider<String>((ref) {
  return 'I have worked for 6 years in animal presentations, giving shows across the state of Florida to a variety of different audiences. '
         'Since I was young, I have had a passion for animals, especially reptiles and the outdoors. '
         'When I was 5, I began catching snakes and keeping them as pets. '
         'Eventually, I worked at Gatorland, where I had the opportunity to start doing shows across the state. '
         'I love what I do and plan to continue providing quality shows and education on animals for the rest of my life.';
});

// List of images for Daniel's gallery
final aboutImagesProvider = Provider<List<String>>((ref) {
  return [
    'assets/images/daniel1.jpg',
    'assets/images/daniel2.jpg',
    'assets/images/daniel3.jpg',
    'assets/images/daniel4.jpg',
    'assets/images/daniel5.jpg',
  ];
});
