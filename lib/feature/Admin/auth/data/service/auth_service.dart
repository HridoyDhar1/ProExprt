import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create user with email+password. Throws FirebaseAuthException on failure.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    // Add simple validations here if you want
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  /// Wrap auth calls with retry/backoff if transient network error occurs.
  Future<T> withRetry<T>(Future<T> Function() fn, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        return await fn();
      } catch (e) {
        attempt++;
        if (attempt > retries) rethrow;
        // simple backoff
        await Future.delayed(Duration(milliseconds: 200 * attempt));
      }
    }
  }
}
