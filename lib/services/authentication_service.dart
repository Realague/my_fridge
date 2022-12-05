import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  MyFridgeUser? currentUser;

  AuthenticationService(this._firebaseAuth);

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentGoogleUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
