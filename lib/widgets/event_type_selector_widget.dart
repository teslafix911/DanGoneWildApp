import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_provider.dart';

class EventTypeSelectorWidget extends ConsumerWidget {
  const EventTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> eventTypes = ref.read(bookingFormProvider.notifier).eventTypes;
    String? selectedEventType = ref.watch(bookingFormProvider).eventType;

    return Container(
      width: MediaQuery.of(context).size.width < 600 ? double.infinity : 400, 
      padding: const EdgeInsets.all(16.0), 
      child: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, 
          children: eventTypes.map((eventType) {
            return RadioListTile<String>(
              title: Text(eventType),
              value: eventType,
              groupValue: selectedEventType,
              onChanged: (String? value) {
                ref.read(bookingFormProvider.notifier).updateEventType(value!); 
                Navigator.of(context).pop(); 
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
