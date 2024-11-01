import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_provider.dart'; 

class AnimalSelectionWidget extends ConsumerWidget {
  const AnimalSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animals = ref.read(bookingFormProvider.notifier).animals; 

    return AlertDialog(
      title: const Text('Select Animals for the Show'),
      content: SizedBox(
        width: 400, 
        height: 400, 
        child: ListView.builder(
          shrinkWrap: true, 
          itemCount: animals.length,
          itemBuilder: (context, index) {
            final animal = animals[index];
            final isSelected = ref.watch(bookingFormProvider).selectedAnimals.contains(animal);
            return CheckboxListTile(
              title: Text(animal),
              value: isSelected,
              onChanged: (bool? value) {
                if (value == true) {
                  ref.read(bookingFormProvider.notifier).selectAnimal(animal);
                } else {
                  ref.read(bookingFormProvider.notifier).deselectAnimal(animal);
                }
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Done'),
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
      ],
    );
  }
}
