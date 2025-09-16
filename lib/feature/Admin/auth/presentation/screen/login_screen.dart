import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/widget/custom_button.dart';
import '../../data/model/app_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String selectedRole = "User";
  Future<void> login(String email, String password, String role) async {
    try {
      // Firebase Authentication
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = credential.user!.uid;

      // Fetch user/admin document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection(role == "Admin" ? "admins" : "users")
          .doc(uid)
          .get();

      if (!doc.exists) {
        Get.snackbar("Login Failed", "No $role account found for this user.");
        return;
      }

      // Debug print to see Firestore data
      print("Firestore doc data: ${doc.data()}");

      // Safely create AppUser
      final data = doc.data() as Map<String, dynamic>? ?? {};
      AppUser user = AppUser(
        uid: data['uid'] ?? uid,                // fallback to Firebase UID
        name: data['name'] ?? 'No Name',
        email: data['email'] ?? email,
        role: data['role'] ?? role,             // fallback to selected role
      );

      // Navigate based on role
      if (user.role == "Admin") {
        Get.toNamed("/navigation");
      } else {
        Get.toNamed("/user_navigation");
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }

  // Future<void> login(String email, String password, String role) async {
  //   try {
  //     // Firebase Authentication
  //     UserCredential credential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //
  //     String uid = credential.user!.uid;
  //
  //     // Fetch user/admin document
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection("serviceApp")
  //         .doc("appData")
  //         .collection(role == "Admin" ? "admins" : "users")
  //         .doc(uid)
  //         .get();
  //
  //     if (!doc.exists) {
  //       throw Exception("No $role account found for this user.");
  //     }
  //
  //     AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
  //
  //     // Navigate based on role
  //     if (user.role == "Admin") {
  //       Get.toNamed("/admin_profile");
  //     } else {
  //       Get.toNamed("/user_navigation");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar("Login Failed", e.message ?? "Something went wrong");
  //   } catch (e) {
  //     Get.snackbar("Login Failed", e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            SvgPicture.asset("assets/images/Tablet login-cuate.svg", height: 350),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      _emailController,
                      selectedRole == "Admin" ? 'Admin Email' : 'User Email',
                      TextInputType.emailAddress,
                      icon: selectedRole == "Admin"
                          ? Icons.admin_panel_settings
                          : Icons.email,
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    CustomButton(
                      name: "Login".tr,
                      width: 220,
                      height: 50,
                      color: Colors.black87,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          // Default superadmin
                          if (email == "superadmin@gmail.com" &&
                              password == "supersecretpassword") {
                            Get.toNamed("/admin_dashboard");
                            return;
                          }

                          login(email, password, selectedRole);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Pass role to Signup screen
                    Get.toNamed("/signup", arguments: {"role": selectedRole});
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedRole = selectedRole == "Admin" ? "User" : "Admin";
                });
              },
              child: Text(selectedRole == "Admin" ? "Switch to User?" : "Admin?"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      TextInputType type, {
        IconData? icon,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter Password' : null,
    );
  }
}
