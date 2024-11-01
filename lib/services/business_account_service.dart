import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessAccountService {
  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?; 
      } else {
        //print("User data not found");
        return null;
      }
    } catch (e) {
      //print("Error fetching user data: $e");
      return null;
    }
  }
}
