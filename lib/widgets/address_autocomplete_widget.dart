
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_provider.dart';
import '../services/address_service.dart';

class AddressAutocompleteWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Color textColor;

  const AddressAutocompleteWidget({
    super.key,
    required this.controller,
    required this.textColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddressAutocompleteWidgetState createState() =>
      _AddressAutocompleteWidgetState();
}

class _AddressAutocompleteWidgetState
    extends ConsumerState<AddressAutocompleteWidget> {
  List<dynamic> suggestions = [];
  bool isLoading = false;
  bool isValidAddress = true;

  @override
  void initState() {
    super.initState();
    // Automatically validate prepopulated address if present
    if (widget.controller.text.isNotEmpty) {
      validatePrepopulatedAddress(widget.controller.text);
    }
  }

  // Function to fetch address suggestions
  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        suggestions = [];
        isValidAddress = false; // Reset validity on empty input
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedSuggestions = await AddressService().getPlaceSuggestions(input);
      setState(() {
        suggestions = fetchedSuggestions;
      });
    } catch (e) {
      setState(() {
        suggestions = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to validate a prepopulated address
  Future<void> validatePrepopulatedAddress(String address) async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedSuggestions = await AddressService().getPlaceSuggestions(address);
      if (fetchedSuggestions.isNotEmpty) {
        // Mark address as valid if suggestions match
        setState(() {
          isValidAddress = true;
          suggestions = [];
        });
        // Fetch lat/lng for further validation
        await fetchLatLngFromAddress(address);
      } else {
        setState(() {
          isValidAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        isValidAddress = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to fetch lat/lng using AddressService
  Future<void> fetchLatLngFromAddress(String address) async {
    setState(() {
      isLoading = true;
    });

    try {
      final placeDetails = await AddressService().getPlaceDetailsFromAddress(address);

      if (placeDetails['lat'] != null && placeDetails['lng'] != null) {
        ref.read(bookingFormProvider.notifier).updateLatLng(
              placeDetails['lat'],
              placeDetails['lng'],
            );

        bool isInServiceArea = ref
            .read(bookingFormProvider.notifier)
            .isWithinRadius(placeDetails['lat'], placeDetails['lng']);

        if (!isInServiceArea && mounted) {
          _showOutsideServiceAreaPopup(context);
        }
      }
    } catch (e) {
      // Handle error fetching place details
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show popup if address is outside service area
  void _showOutsideServiceAreaPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Outside Service Area'),
          content: const Text(
            'The address you provided is outside our service area. '
            'We currently serve the Central Florida area. Please contact us if you are close to this area.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.controller.clear();
                ref.read(bookingFormProvider.notifier).updateAddress('');
                Navigator.of(context).pop();
              },
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address input field
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Address',
              labelStyle: TextStyle(color: widget.textColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.textColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.textColor),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorText: isValidAddress ? null : 'Please select a valid address',
            ),
            style: TextStyle(color: widget.textColor),
            onChanged: (value) {
              fetchSuggestions(value);
              setState(() {
                isValidAddress = false; 
              });
            },
          ),
          const SizedBox(height: 8.0),
          // Displaying suggestions in ListView
          suggestions.isNotEmpty
              ? Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          suggestions[index]['description'],
                          style: TextStyle(color: widget.textColor),
                        ),
                        onTap: () async {
                          setState(() {
                            isValidAddress = true;
                          });
                          
                          widget.controller.text = suggestions[index]['description'];
                          widget.controller.selection =
                              TextSelection.fromPosition(
                                  TextPosition(offset: widget.controller.text.length));

                          ref
                              .read(bookingFormProvider.notifier)
                              .updateAddress(suggestions[index]['description']);

                          await fetchLatLngFromAddress(suggestions[index]['description']);
                          setState(() {
                            suggestions = [];
                          });
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(), 

          if (isLoading) ...[
            const SizedBox(height: 10),
            const Center(child: CircularProgressIndicator()), 
          ]
        ],
      ),
    );
  }

  // Validate address before proceeding
  bool validateAddress() {
    if (widget.controller.text.isEmpty || !isValidAddress) {
      setState(() {
        isValidAddress = false;
      });
      return false; 
    }
    return true; 
  }
}
