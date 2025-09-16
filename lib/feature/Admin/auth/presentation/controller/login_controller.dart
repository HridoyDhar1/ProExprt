import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password, String role) async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // Fetch user document to verify role
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        Get.snackbar('Error', 'User data not found in database');
        return;
      }

      String userRole = userDoc['role'] ?? 'User';

      if (userRole != role) {
        Get.snackbar('Error', 'Incorrect role selected');
        await _auth.signOut(); // Sign out immediately
        return;
      }

      Get.snackbar('Success', 'Login successful as $role');
      // Navigate to respective dashboard
      if (role == 'Admin') {
        Get.offAllNamed('/admin_dashboard');
      } else {
        Get.offAllNamed('/user_dashboard');
      }

    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') message = 'User not found';
      else if (e.code == 'wrong-password') message = 'Incorrect password';
      else message = e.message ?? 'Login failed';
      Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
