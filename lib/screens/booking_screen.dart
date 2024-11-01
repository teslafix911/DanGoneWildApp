import 'package:dangonewild/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';
import '../widgets/address_autocomplete_widget.dart';
import '../widgets/animal_selection_widget.dart';
import '../widgets/bug_report_button.dart';
import '../widgets/calendar.dart';
import '../widgets/event_type_selector_widget.dart';
import '../widgets/time_slot_selector_widget.dart';

class BookingScreen extends ConsumerWidget {
  BookingScreen({super.key});

  final _formKey = GlobalKey<FormState>(); // Form key to track validation
  final _eventDescriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingForm = ref.watch(bookingFormProvider);
    //print('Booking Form Data: Name: ${bookingForm.name}, Email: ${bookingForm.email}, Phone: ${bookingForm.phoneNumber}, Address: ${bookingForm.address}');

    // Update the addressController with the address from the provider whenever the state changes
    addressController.text = bookingForm.address ?? '';  // Keep the TextEditingController in sync with the booking form provider
    //final calendarState = ref.watch(calendarProvider);
    ref.read(bookingFormProvider.notifier).generateTimeSlots();

    // Use MediaQuery to get full screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Gator Show'),
        backgroundColor: const Color(0xFF29AB87),  
      ),
      body: Stack(
        children: [
          // Background image covering the full screen using MediaQuery
          SizedBox(
            height: size.height, 
            width: size.width,    
            child: Image.asset(
              'assets/jungle_bg.png', 
              fit: BoxFit.cover,       
            ),
          ),
          // Semi-transparent overlay to improve readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), 
            ),
          ),
          // Main content on top of the background
          SingleChildScrollView(
            child: Center( 
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000), 
                padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                child: Form(
                  key: _formKey, 
                  child: Column(
                    children: [
                      // Name input
                      TextFormField(
                        initialValue: ref.watch(bookingFormProvider).name ?? '',
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).nameValid ? Colors.white : Colors.red, 
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).nameValid ? Colors.white : Colors.red,  
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorText: !ref.watch(bookingFormProvider).nameValid ? "Please enter your name" : null,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) => ref.read(bookingFormProvider.notifier).updateName(value),
                      ),
                      // Address input using AddressAutocompleteWidget
                      AddressAutocompleteWidget(
                        controller: addressController,
                        textColor: Colors.white, // White text for booking screen
                      ),
                      // Email input with validation
                      TextFormField(
                        initialValue: ref.watch(bookingFormProvider).email ?? '',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),  // Keep const here
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).emailValid ? Colors.white : Colors.red,  // Dynamic state
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).emailValid ? Colors.white : Colors.red,  // Dynamic state
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorText: !ref.watch(bookingFormProvider).emailValid ? "Please enter a valid email address (e.g., yourname@example.com)" : null,
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => ref.read(bookingFormProvider.notifier).updateEmail(value),
                      ),
                      // Phone number input with validation
                      TextFormField(
                        initialValue: ref.watch(bookingFormProvider).phoneNumber ?? '',
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).phoneNumberValid ? Colors.white : Colors.red,  // Dynamic state
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).phoneNumberValid ? Colors.white : Colors.red,  // Dynamic state
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red), // Highlight in red if invalid
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorText: !ref.watch(bookingFormProvider).phoneNumberValid ? "Please enter a valid phone number, including the area code" : null,
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => ref.read(bookingFormProvider.notifier).updatePhoneNumber(value),
                      ),
                      const SizedBox(height: 20),
                      // Event type field with clickable line
                      GestureDetector(
                      onTap: () {
                        // Show the EventTypeSelectorWidget in a dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Dialog(
                              child: EventTypeSelectorWidget(), // The widget for selecting event type
                            );
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Event Type',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).eventTypeValid ? Colors.white : Colors.red, 
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).eventTypeValid ? Colors.white : Colors.red,  
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red), 
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorText: !ref.watch(bookingFormProvider).eventTypeValid ? "Please select an event type" : null,
                        ),
                        child: Text(
                          ref.watch(bookingFormProvider).eventType ?? 'Select Event Type', 
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                      // Event description
                      TextFormField(
                        controller: _eventDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Event Description',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).eventDescriptionValid ? Colors.white : Colors.red,  
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).eventDescriptionValid ? Colors.white : Colors.red,
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red), 
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorText: !ref.watch(bookingFormProvider).eventDescriptionValid ? "Please enter a description of the event" : null,
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        onChanged: (value) => ref.read(bookingFormProvider.notifier).updateEventDescription(value),
                      ),
                      const SizedBox(height: 20),
                      // Calendar widget for date selection
                      GestureDetector(
                        onTap: () {
                          // Trigger fetching availability for the current month when the user taps
                          final DateTime currentMonth = DateTime.now();
                          ref.read(calendarProvider.notifier).fetchAvailabilityForMonth(currentMonth);

                          // Then open the modal to show the calendar
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CalendarWidget(
                                onDateSelected: (DateTime selectedDate) {
                                  // Update the selected date in the booking form provider
                                  ref.read(bookingFormProvider.notifier).updateDate(selectedDate);
                                },
                                fetchAvailabilityForMonth: (DateTime month) {
                                  // Fetch availability for any new month the user navigates to
                                  ref.read(calendarProvider.notifier).fetchAvailabilityForMonth(month);
                                },
                              );
                            },
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ref.watch(bookingFormProvider).selectedDateValid ? Colors.white : Colors.red, 
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ref.watch(bookingFormProvider).selectedDateValid ? Colors.white : Colors.red,  
                              ),
                            ),
                            errorText: !ref.watch(bookingFormProvider).selectedDateValid ? "Please select a valid date" : null,
                          ),
                          child: Text(
                            ref.watch(bookingFormProvider).selectedDate == null
                                ? 'Select a Date'
                                : DateFormat('yMMMd').format(ref.watch(bookingFormProvider).selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),                  
                      // Time selection line-style (matching the other form fields)
                      GestureDetector(
                        onTap: () {
                          // Check if a date has been selected first
                          if (bookingForm.selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a date first.')),
                            );
                            return;
                          }
                          // Show the TimeSlotSelectorWidget directly in a dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: TimeSlotSelectorWidget(
                                  onTimeSelected: (String selectedTime) {
                                    // Use the _convertToTimeOfDay method to convert the String to TimeOfDay
                                    TimeOfDay timeOfDay = ref.read(bookingFormProvider.notifier).convertToTimeOfDay(selectedTime); 
                                    // Update the selected time in your provider
                                    ref.read(bookingFormProvider.notifier).updateTime(timeOfDay);
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  showStartTime: ref.read(calendarProvider).showStartTime ?? DateTime.now(), // Pass showStartTime
                                ),
                              );
                            },
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Time',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ref.watch(bookingFormProvider).selectedTimeValid ? Colors.white : Colors.red,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ref.watch(bookingFormProvider).selectedTimeValid ? Colors.white : Colors.red,
                              ),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorText: !ref.watch(bookingFormProvider).selectedTimeValid ? "Please select a valid time" : null,
                          ),
                          child: Text(
                            bookingForm.selectedTime != null
                                ? ref.read(bookingFormProvider.notifier).formatTimeOfDay(bookingForm.selectedTime!)
                                : 'Select a Time',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animal selection with line-style selection
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AnimalSelectionWidget(); 
                            },
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Animals',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                              color: ref.watch(bookingFormProvider).selectedAnimalsValid ? Colors.white : Colors.red,
                            ),
                          ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ref.watch(bookingFormProvider).selectedAnimalsValid ? Colors.white : Colors.red,
                              ),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red), 
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorText: !ref.watch(bookingFormProvider).selectedAnimalsValid ? "Please select at least one animal" : null,
                          ),
                          child: Text(
                            bookingForm.selectedAnimals.isEmpty
                                ? 'Select Animals'
                                : bookingForm.selectedAnimals.join(', '),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Submit button
                      ElevatedButton(
                        onPressed: () async {
                          // Set loading state
                          ref.read(bookingFormProvider.notifier).setLoading(true); 

                          // Validate the form first
                          if (ref.read(bookingFormProvider.notifier).validateBookingForm()) {
                            try {
                              // Proceed to confirmation, await this if it is async
                              await ref.read(bookingFormProvider.notifier).proceedToConfirmation(context, ref);

                              // Check if the widget is still mounted before using the context
                              if (context.mounted) {
                                // Optionally handle any post-confirmation logic here
                              }
                            } catch (error) {
                              // Handle any errors that may occur during the confirmation process
                              if (context.mounted) { 
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('An error occurred: $error')),
                                );
                              }
                            } finally {
                              // Clear loading state
                              ref.read(bookingFormProvider.notifier).setLoading(false); 
                            }
                          } else {
                            // Show a message or handle the invalid form case
                            if (context.mounted) { // Check if mounted before using context
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill in all required fields')),
                              );
                            }

                            // Clear loading state
                            ref.read(bookingFormProvider.notifier).setLoading(false);
                          }
                        },
                        child: ref.watch(bookingFormProvider).isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Submit Booking'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Place the Bug Report Button on the top-right corner
          BugReportButton(),
        ],
      ),
    );
  }
}
