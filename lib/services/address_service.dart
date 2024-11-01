import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressService {
  static const String baseUrlSuggestions =
      'https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/getPlaceSuggestions';

  static const String baseUrlPlaceDetailsFromAddress =
      'https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/getPlaceDetailsFromAddress';

  static const String baseUrlPlaceDetails =
      'https://us-central1-dan-gone-wild-7719d.cloudfunctions.net/getPlaceDetails';

  // Fetch address suggestions based on user input
  Future<List<dynamic>> getPlaceSuggestions(String input) async {
    //print('Calling getPlaceSuggestions with input: $input');
    final response = await http.get(Uri.parse('$baseUrlSuggestions?input=$input'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch place suggestions');
    }
  }

  // Fetch place_id based on the address
  Future<Map<String, dynamic>> getPlaceDetailsFromAddress(String address) async {
    //print('Calling getPlaceDetailsFromAddress with address: $address');
    //('Calling getPlaceDetailsFromAddress with address: $address');

    final response = await http.get(Uri.parse('$baseUrlPlaceDetailsFromAddress?address=$address'));

    if (response.statusCode == 200) {
      //print('Response from getPlaceDetailsFromAddress: ${response.body}');
      return json.decode(response.body); // This should return place_id
    } else {
      //print('Error fetching place ID. Status code: ${response.statusCode}'); 
      throw Exception('Failed to fetch place ID from address');
    }
  }

  // Fetch lat/lng based on place_id
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    //print('Calling getPlaceDetails with placeId: $placeId');
    //print('Calling getPlaceDetails with placeId: $placeId'); 

    final response = await http.get(Uri.parse('$baseUrlPlaceDetails?placeId=$placeId'));
    //print('API response for suggestions: ${response.body}');

    if (response.statusCode == 200) {
      //print('Response from getPlaceDetails: ${response.body}'); 
      return json.decode(response.body); // This should return lat/lng
    } else {
      //print('Error fetching place details. Status code: ${response.statusCode}'); 
      throw Exception('Failed to fetch place details');
    }
  }
}