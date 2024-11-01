
import 'package:dangonewild/screens/payment_screen.dart';
import 'package:dangonewild/widgets/cave_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dangonewild/providers/booking_provider.dart'; 
import 'package:dangonewild/widgets/time_slot_selector_widget.dart'; // Import the TimeSlotSelectorWidget
import 'package:intl/intl.dart';

import '../providers/calendar_provider.dart';
import '../widgets/address_autocomplete_widget.dart';
import '../widgets/animal_selection_widget.dart';
import '../widgets/bug_report_button.dart';
import '../widgets/calendar.dart';
import '../widgets/event_type_selector_widget.dart';
/*
class BookingConfirmationPage extends ConsumerWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingForm = ref.watch(bookingFormProvider);

    // Format date
    final String formattedDate = bookingForm.selectedDate != null
        ? DateFormat('yMMMd').format(bookingForm.selectedDate!)
        : 'Not selected';

    // Format time
    final String formattedTime = bookingForm.selectedTime != null
        ? bookingForm.selectedTime!.format(context)
        : 'Not selected';

    // Event Type and Event Description
    final String eventType = bookingForm.eventType ?? 'Not selected';
    final String eventDescription = bookingForm.eventDescription ?? 'No description provided';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Your Booking'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Main content wrapped in CaveBackground
          CaveBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    'Review and Confirm Your Booking Details:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display and Edit Name
                  _buildDetailRow(
                    context,
                    'Name',
                    bookingForm.name ?? 'Not provided',
                    onEdit: () {
                      _editField(context, 'Name', bookingForm.name, (newValue) {
                        ref.read(bookingFormProvider.notifier).updateName(newValue);
                      });
                    },
                  ),

                  // Display and Edit Address
                  _buildDetailRow(
                    context,
                    'Address',
                    bookingForm.address ?? 'Not provided',
                    onEdit: () {
                      _editAddressField(context, ref);
                    },
                  ),

                  // Display and Edit Email
                  _buildDetailRow(
                    context,
                    'Email',
                    bookingForm.email ?? 'Not provided',
                    onEdit: () {
                      _editField(context, 'Email', bookingForm.email, (newValue) {
                        ref.read(bookingFormProvider.notifier).updateEmail(newValue);
                      });
                    },
                  ),

                  // Display and Edit Phone Number
                  _buildDetailRow(
                    context,
                    'Phone Number',
                    bookingForm.phoneNumber ?? 'Not provided',
                    onEdit: () {
                      _editField(context, 'Phone Number', bookingForm.phoneNumber, (newValue) {
                        ref.read(bookingFormProvider.notifier).updatePhoneNumber(newValue);
                      });
                    },
                  ),

                  // Display and Edit Date (Using CalendarWidget)
                  _buildDetailRow(
                    context,
                    'Selected Date',
                    formattedDate,
                    onEdit: () {
                      _editDate(context, ref);
                    },
                  ),

                  // Display and Edit Time (Using TimeSlotSelectorWidget)
                  _buildDetailRow(
                    context,
                    'Selected Time',
                    formattedTime,
                    onEdit: () {
                      _editTime(context, ref);
                    },
                  ),

                  // Event Type
                  _buildDetailRow(
                    context,
                    'Event Type',
                    eventType,
                    onEdit: () {
                      _editEventType(context, ref);
                    },
                  ),

                  // Event Description
                  _buildDetailRow(
                    context,
                    'Event Description',
                    eventDescription,
                    onEdit: () {
                      ref.read(bookingFormProvider.notifier).showEventDescriptionEditModal(context);
                    },
                  ),

                  // Display and Edit Animals
                  _buildDetailRow(
                    context,
                    'Selected Animals',
                    bookingForm.selectedAnimals.isNotEmpty 
                        ? bookingForm.selectedAnimals.join(', ') 
                        : 'No animals selected',
                    onEdit: () {
                      _editAnimals(context, ref);
                    },
                  ),
                  
                  const SizedBox(height: 40),

                  // Confirm Booking and Proceed to Payment
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                      ),
                      onPressed: () {
                        // Only navigate to PaymentScreen without submitting to Firestore yet
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                firstName: bookingForm.name ?? 'Guest', 
                                selectedDate: bookingForm.selectedDate!, 
                                selectedTime: bookingForm.selectedTime!, 
                                selectedAnimals: bookingForm.selectedAnimals, 
                                location: bookingForm.address ?? 'Unknown Location',  
                                eventType: bookingForm.eventType ?? 'Unknown Event Type',
                                eventDescription: bookingForm.eventDescription ?? 'No description provided',
                                email: bookingForm.email ?? 'No email provided',  
                                phoneNumber: bookingForm.phoneNumber ?? 'No phone number provided',  
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Confirm Booking and Proceed to Payment'),
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

  // Helper method to build a row with detail and edit button
  Widget _buildDetailRow(BuildContext context, String title, String detail, {required VoidCallback onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Make title text white
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.white, // Make detail text white
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white, // Set button text to white
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  class BookingConfirmationPage extends ConsumerWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingForm = ref.watch(bookingFormProvider);

    // Format date
    final String formattedDate = bookingForm.selectedDate != null
        ? DateFormat('yMMMd').format(bookingForm.selectedDate!)
        : 'Not selected';

    // Format time
    final String formattedTime = bookingForm.selectedTime != null
        ? bookingForm.selectedTime!.format(context)
        : 'Not selected';

    // Event Type and Event Description
    final String eventType = bookingForm.eventType ?? 'Not selected';
    final String eventDescription = bookingForm.eventDescription ?? 'No description provided';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Your Booking'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Ensure the CaveBackground has a child
          CaveBackground(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600), // Set max width for the form
                padding: const EdgeInsets.all(16.0), // Add padding inside the container
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Dark transparent background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListView(
                  shrinkWrap: true, // Prevents the ListView from expanding infinitely
                  children: [
                    const Text(
                      'Review and Confirm Your Booking Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Display and Edit Name
                    _buildDetailRow(
                      context,
                      'Name',
                      bookingForm.name ?? 'Not provided',
                      onEdit: () {
                        _editField(context, 'Name', bookingForm.name, (newValue) {
                          ref.read(bookingFormProvider.notifier).updateName(newValue);
                        });
                      },
                    ),

                    // Display and Edit Address
                    _buildDetailRow(
                      context,
                      'Address',
                      bookingForm.address ?? 'Not provided',
                      onEdit: () {
                        _editAddressField(context, ref);
                      },
                    ),

                    // Display and Edit Email
                    _buildDetailRow(
                      context,
                      'Email',
                      bookingForm.email ?? 'Not provided',
                      onEdit: () {
                        _editField(context, 'Email', bookingForm.email, (newValue) {
                          ref.read(bookingFormProvider.notifier).updateEmail(newValue);
                        });
                      },
                    ),

                    // Display and Edit Phone Number
                    _buildDetailRow(
                      context,
                      'Phone Number',
                      bookingForm.phoneNumber ?? 'Not provided',
                      onEdit: () {
                        _editField(context, 'Phone Number', bookingForm.phoneNumber, (newValue) {
                          ref.read(bookingFormProvider.notifier).updatePhoneNumber(newValue);
                        });
                      },
                    ),

                    // Display and Edit Date (Using CalendarWidget)
                    _buildDetailRow(
                      context,
                      'Selected Date',
                      formattedDate,
                      onEdit: () {
                        _editDate(context, ref);
                      },
                    ),

                    // Display and Edit Time (Using TimeSlotSelectorWidget)
                    _buildDetailRow(
                      context,
                      'Selected Time',
                      formattedTime,
                      onEdit: () {
                        _editTime(context, ref);
                      },
                    ),
/*
                    // Event Type
                    _buildDetailRow(
                      context,
                      'Event Type',
                      eventType,
                      onEdit: () {
                        _editEventType(context, ref);
                      },
                    ),*/

// Event Type
_buildDetailRow(
  context,
  'Event Type',
  eventType,
  onEdit: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: EventTypeSelectorWidget(), // Replacing the edit function with the widget in a dialog
        );
      },
    );
  },
),
                    // Event Description
                    _buildDetailRow(
                      context,
                      'Event Description',
                      eventDescription,
                      onEdit: () {
                        ref.read(bookingFormProvider.notifier).showEventDescriptionEditModal(context);
                      },
                    ),

                    // Display and Edit Animals
                    _buildDetailRow(
                      context,
                      'Selected Animals',
                      bookingForm.selectedAnimals.isNotEmpty 
                          ? bookingForm.selectedAnimals.join(', ') 
                          : 'No animals selected',
                      onEdit: () {
                        _editAnimals(context, ref);
                      },
                    ),

                    const SizedBox(height: 40),

                    // Confirm Booking and Proceed to Payment
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                        ),
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  firstName: bookingForm.name ?? 'Guest',
                                  selectedDate: bookingForm.selectedDate!,
                                  selectedTime: bookingForm.selectedTime!,
                                  selectedAnimals: bookingForm.selectedAnimals,
                                  location: bookingForm.address ?? 'Unknown Location',
                                  eventType: bookingForm.eventType ?? 'Unknown Event Type',
                                  eventDescription: bookingForm.eventDescription ?? 'No description provided',
                                  email: bookingForm.email ?? 'No email provided',
                                  phoneNumber: bookingForm.phoneNumber ?? 'No phone number provided',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Confirm Booking and Proceed to Payment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bug report button
          BugReportButton(),
        ],
      ),
    );
  }

  // Helper method to build a row with detail and edit button
  Widget _buildDetailRow(BuildContext context, String title, String detail, {required VoidCallback onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Make title text white
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.white, // Make detail text white
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white, // Set button text to white
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to show a dialog for editing text fields
  void _editField(BuildContext context, String title, String? currentValue, Function(String) onSave) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSave(controller.text); // Save the new value
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to show a modal for editing date using the custom CalendarWidget
  void _editDate(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CalendarWidget(
          onDateSelected: (DateTime selectedDate) {
            // Update the selected date in the booking form provider
            ref.read(bookingFormProvider.notifier).updateDate(selectedDate);
            Navigator.pop(context); // Close the calendar modal after date selection
          },
          fetchAvailabilityForMonth: (DateTime month) {
            // Fetch availability for the selected month
            ref.read(calendarProvider.notifier).fetchAvailabilityForMonth(month);
          },
        );
      },
    );
  }

  // Helper method to show a dialog for selecting time using the custom TimeSlotSelectorWidget
  void _editTime(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: TimeSlotSelectorWidget(
            onTimeSelected: (String selectedTime) {
              // Convert the selected time string to TimeOfDay and update it
              TimeOfDay timeOfDay = ref.read(bookingFormProvider.notifier).convertToTimeOfDay(selectedTime); 
              ref.read(bookingFormProvider.notifier).updateTime(timeOfDay); // Update the selected time in the provider
              Navigator.pop(context); // Close the dialog after time is selected
            },
            showStartTime: ref.read(calendarProvider).showStartTime ?? DateTime.now(), // Pass showStartTime
          ),
        );
      },
    );
  }
/*
  // Helper method to show a dialog for editing event type
  void _editEventType(BuildContext context, WidgetRef ref) {
    final List<String> eventTypes = ref.read(bookingFormProvider.notifier).eventTypes;
    String? selectedEventType = ref.read(bookingFormProvider).eventType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Event Type'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: eventTypes.map((eventType) {
                  return RadioListTile<String>(
                    title: Text(
                      eventType,
                      style: const TextStyle(color: Colors.black), // Event type text white
                    ),
                    value: eventType,
                    groupValue: selectedEventType,
                    onChanged: (String? value) {
                      setState(() {
                        selectedEventType = value;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedEventType != null) {
                  ref.read(bookingFormProvider.notifier).updateEventType(selectedEventType!);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }*/
}

// Method to show the animal selection dialog
void _editAnimals(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return const AnimalSelectionWidget(); // Call the separate widget
    },
  );
}

// Method to edit address with places API
void _editAddressField(BuildContext context, WidgetRef ref) {
  final TextEditingController addressController = TextEditingController(
    text: ref.read(bookingFormProvider).address, // Set the initial text
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Address'),
        content: SizedBox(
          height: 200,  // Set a fixed height to constrain the list
          width: 300,   // Set a fixed width to avoid intrinsic width issues
          child: AddressAutocompleteWidget(
            controller: addressController, // Pass the controller
            textColor: Colors.black, // Black text for confirmation screen
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save the selected address from the controller to the provider
              ref.read(bookingFormProvider.notifier).updateAddress(addressController.text);
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel and close dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}