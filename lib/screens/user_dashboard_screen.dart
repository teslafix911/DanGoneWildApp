
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/user_dashboard_provider.dart';
import '../utils/date_time_utils.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the bookingsProvider for data
    final bookingsAsyncValue = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Your Dashboard'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications pressed')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account settings pressed')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Events Section Title
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Display available bookings from Firestore
            Expanded(
              child: bookingsAsyncValue.when(
                data: (bookings) {
                  // If no bookings are found
                  if (bookings.isEmpty) {
                    return const Center(
                      child: Text('No upcoming events found.'),
                    );
                  }

                  // If bookings are found, display them in a list
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('Event: ${booking.eventType}'),
                          subtitle: Text(
                            'Date: ${DateFormat.yMMMd().format(booking.selectedDate!)}\n'
                            'Time: ${booking.selectedTime?.format(context)}\n'
                            'Address: ${booking.address}\n'
                            'Animals: ${booking.selectedAnimals.join(', ')}\n'
                            'Created At: ${formatToEasternTime(booking.createdAt!)}\n'
                            'Name: ${booking.name}\n'
                            'Email: ${booking.email}\n'
                            'Phone: ${booking.phoneNumber}\n'
                            'Description: ${booking.eventDescription}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Viewing details for ${booking.eventType}')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading bookings: $error'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Book New Event Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(userDashboardProvider.notifier).navigateToBookingScreen(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Book New Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}