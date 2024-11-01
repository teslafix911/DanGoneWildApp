import 'package:flutter_riverpod/flutter_riverpod.dart';

// Animal data model
class Animal {
  final String name;
  final String description;
  final List<String> imageUrls; 

  Animal({
    required this.name,
    required this.description,
    required this.imageUrls,
  });
}

// List of animals with details
final animalsProvider = Provider<List<Animal>>((ref) {
  return [
    Animal(
      name: 'Alligator/Caimen',
      description: 'Alligators and caimans are reptiles known for their powerful jaws and large size.',
      imageUrls: [
        'assets/alligator1.jpg',
        'assets/alligator2.jpg',
        'assets/alligator3.jpg',
      ],
    ),
    Animal(
      name: 'Rhino Iguana',
      description: 'Rhino Iguanas are large, heavy-bodied lizards found in the Caribbean.',
      imageUrls: [
        'assets/rhinoiguana1.jpg',
        'assets/rhinoiguana2.jpg',
        'assets/rhinoiguana3.jpg',
      ],
    ),
    Animal(
      name: 'Day Geckos',
      description: 'Day geckos are small, colorful lizards native to Madagascar.',
      imageUrls: [
        'assets/daygecko1.jpg',
        'assets/daygecko2.jpg',
        'assets/daygecko3.jpg',
      ],
    ),
    Animal(
      name: 'Tarantula',
      description: 'Tarantulas are large, hairy spiders known for their size and calm demeanor.',
      imageUrls: [
        'assets/tarantula1.jpg',
        'assets/tarantula2.jpg',
        'assets/tarantula3.jpg',
      ],
    ),
    Animal(
      name: 'False Water Cobra',
      description: 'The false water cobra is a rear-fanged snake known for mimicking a cobra.',
      imageUrls: [
        'assets/falsewatercobra1.jpg',
        'assets/falsewatercobra2.jpg',
        'assets/falsewatercobra3.jpg',
      ],
    ),
    Animal(
      name: 'Ball Python',
      description: 'Ball Pythons are small, non-venomous constrictors native to Africa.',
      imageUrls: [
        'assets/ballpython1.jpg',
        'assets/ballpython2.jpg',
        'assets/ballpython3.jpg',
      ],
    ),
    Animal(
      name: 'Scorpion',
      description: 'Scorpions are predatory arachnids with a venomous sting.',
      imageUrls: [
        'assets/scorpion1.jpg',
        'assets/scorpion2.jpg',
        'assets/scorpion3.jpg',
      ],
    ),
  ];
});
