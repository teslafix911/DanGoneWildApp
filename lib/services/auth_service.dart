import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth;
  final Logger _logger = Logger(); 

  AuthService(this._auth);

  // Method to listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing in', error: e); 
      rethrow;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential; 
    } catch (e) {
      _logger.e('Error signing up', error: e); 
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendSignInLink(String email) async {
    final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://www.example.com/finishSignUp',  
      handleCodeInApp: true,
      androidPackageName: 'com.dangonewild.app', 
      androidInstallApp: true,
      androidMinimumVersion: '12',
      iOSBundleId: 'com.dangonewild.app', 
    );

    try {
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      _logger.i('Sign-in email sent.'); 
    } catch (e) {
      _logger.e('Error sending sign-in email', error: e); 
      rethrow;
    }
  }

  Future<User?> handleEmailLinkSignIn(String email, String emailLink) async {
    if (_auth.isSignInWithEmailLink(emailLink)) {
      try {
        final UserCredential userCredential = await _auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );
        return userCredential.user;
      } catch (e) {
        _logger.e('Error signing in with email link', error: e);
        rethrow;
      }
    }
    return null;
  }
}
