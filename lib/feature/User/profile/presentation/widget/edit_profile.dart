// import 'dart:io';
// import 'package:app/core/widget/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EditUserProfileScreen extends StatefulWidget {
//   const EditUserProfileScreen({Key? key}) : super(key: key);
//
//   static const String name = '/edit_userprofile';
//
//   @override
//   State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
// }
//
// class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final picker = ImagePicker();
//   File? _profileImage;
//   bool _isLoading = false;
//
//   // Mock user data
//   Map<String, dynamic> _userData = {
//     "name": "John Doe",
//     "email": "johndoe@example.com",
//     "number": "1234567890",
//     "location": "123 Main Street",
//     "workType": "",
//     "country": "USA",
//     "employees": "",
//     "imageUrl": null,
//   };
//
//   // Controllers
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _workTypeController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _employeesController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   void _loadUserData() {
//     _nameController.text = _userData["name"];
//     _emailController.text = _userData["email"];
//     _phoneController.text = _userData["number"];
//     _addressController.text = _userData["location"];
//     _workTypeController.text = _userData["workType"];
//     _countryController.text = _userData["country"];
//     _employeesController.text = _userData["employees"];
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );
//
//     if (pickedFile != null) {
//       setState(() => _profileImage = File(pickedFile.path));
//     }
//   }
//
//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Simulate a save delay
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Update mock user data
//       _userData = {
//         "name": _nameController.text,
//         "email": _emailController.text,
//         "number": _phoneController.text,
//         "location": _addressController.text,
//         "workType": _workTypeController.text,
//         "country": _countryController.text,
//         "employees": _employeesController.text,
//         "imageUrl": _profileImage?.path,
//       };
//
//       Get.snackbar("Success", "Profile updated successfully");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to update profile");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     required TextEditingController controller,
//     TextInputType keyboardType = TextInputType.text,
//     bool readOnly = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: readOnly,
//         validator: (value) => value!.isEmpty ? "Please enter $label" : null,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.grey[600]),
//           labelText: label,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//       ),
//     );
//   }
//
//   ImageProvider _getProfileImage() {
//     if (_profileImage != null) {
//       return FileImage(_profileImage!);
//     } else if (_userData["imageUrl"] != null) {
//       return FileImage(File(_userData["imageUrl"]));
//     }
//     return const AssetImage("assets/profile_placeholder.png");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text("Edit Profile"),
//         centerTitle: true,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundImage: _getProfileImage(),
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: CircleAvatar(
//                             radius: 18,
//                             backgroundColor: Colors.blue,
//                             child: const Icon(Icons.camera_alt,
//                                 color: Colors.white, size: 20),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildTextField(
//                         label: "Name",
//                         icon: Icons.person,
//                         controller: _nameController),
//                     _buildTextField(
//                       label: "Email",
//                       icon: Icons.email,
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       readOnly: true,
//                     ),
//                     _buildTextField(
//                       label: "Phone",
//                       icon: Icons.phone,
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                     ),
//                     _buildTextField(
//                       label: "Address",
//                       icon: Icons.location_on,
//                       controller: _addressController,
//                     ),
//                     const SizedBox(height: 30),
//                     CustomButton(
//                       name: "Save",
//                       width: 200,
//                       height: 50,
//                       color: Colors.black87,
//                       onPressed: _saveProfile,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'dart:io';
import 'package:app/core/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);
  static const String name = '/edit_userprofile';

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _profileImage;
  bool _isLoading = false;

  Map<String, dynamic>? _userData;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("serviceApp")
          .doc("appData")
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _userData = doc.data();
        _nameController.text = _userData?["name"] ?? "";
        _emailController.text = _userData?["email"] ?? "";
        _phoneController.text = _userData?["number"] ?? "";
        _addressController.text = _userData?["location"] ?? "";
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? imageUrl = _userData?["profileImage"];
      if (_profileImage != null) {
        // Upload new profile image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("users/${user.uid}/profile.jpg");
        await storageRef.putFile(_profileImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      Map<String, dynamic> updatedData = {
        "name": _nameController.text.trim(),
        "number": _phoneController.text.trim(),
        "location": _addressController.text.trim(),
        "profileImage": imageUrl,
      };

      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("users")
          .doc(user.uid)
          .update(updatedData);

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
    setState(() => _isLoading = false);
  }

  ImageProvider _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_userData?["profileImage"] != null) {
      return NetworkImage(_userData!["profileImage"]);
    }
    return const AssetImage("assets/profile_placeholder.png");
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _getProfileImage(),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  label: "Name",
                  icon: Icons.person,
                  controller: _nameController),
              _buildTextField(
                label: "Email",
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              _buildTextField(
                label: "Phone",
                icon: Icons.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: "Address",
                icon: Icons.location_on,
                controller: _addressController,
              ),
              const SizedBox(height: 30),
              CustomButton(
                name: "Save",
                width: 200,
                height: 50,
                color: Colors.black87,
                onPressed: _saveProfile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
