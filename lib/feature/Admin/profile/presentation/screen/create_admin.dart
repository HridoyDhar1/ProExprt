import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/widget/custom_button.dart';
import '../../../../../core/widget/map_picker.dart';
import '../../../../../core/widget/subscription_screen.dart';
import '../../data/model/admin_model.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  static const String name = '/admin_profile';

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Dropdown selections
  String? _selectedWorkType;
  String? _selectedCountry;
  String? _selectedEmployees;

  // Image picker
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Dropdown options
  final List<String> workTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
  ];
  final List<String> countries = ['USA', 'India', 'Canada', 'UK', 'Australia'];
  final List<String> employeesCount = ['1-10', '11-50', '51-200', '200+'];

  // Location picker
  Future<void> _openMapAndPickLocation() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(),
      ),
    );

    if (pickedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pickedLocation.latitude,
        pickedLocation.longitude,
      );

      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        _locationController.text = address;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('assets/default_avatar.png')
                  as ImageProvider,
                  backgroundColor: Colors.grey.shade200,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                        _nameController, 'Name', Icons.person, TextInputType.text),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _emailController, 'Email', Icons.email, TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _numberController, 'Number', Icons.phone, TextInputType.phone),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _locationController, 'Location', Icons.location_on,
                        TextInputType.text, _openMapAndPickLocation, true),
                    const SizedBox(height: 20),
                    _buildDropdown('Work Type',
                        items: workTypes,
                        selectedValue: _selectedWorkType,
                        onChanged: (value) => setState(() => _selectedWorkType = value),
                        icon: Icons.work),
                    const SizedBox(height: 15),
                    _buildDropdown('Country',
                        items: countries,
                        selectedValue: _selectedCountry,
                        onChanged: (value) => setState(() => _selectedCountry = value),
                        icon: Icons.flag),
                    const SizedBox(height: 15),
                    _buildDropdown('Number of Employees',
                        items: employeesCount,
                        selectedValue: _selectedEmployees,
                        onChanged: (value) => setState(() => _selectedEmployees = value),
                        icon: Icons.group),
                    const SizedBox(height: 30),
                    CustomButton(
                      name: "Submit",
                      width: 200,
                      height: 50,
                      color: Colors.black87,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Generate UID for the admin (you can also use FirebaseAuth or a random ID)
                          String uid = FirebaseAuth.instance.currentUser?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

                          // Prepare the admin data
                          Map<String, dynamic> adminData = {
                            'name': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'number': _numberController.text.trim(),
                            'location': _locationController.text.trim(),
                            'workType': _selectedWorkType,
                            'country': _selectedCountry,
                            'employees': _selectedEmployees,
                            'createdAt': FieldValue.serverTimestamp(),
                          };

                          try {
                            // Save data to Firestore
                            await FirebaseFirestore.instance
                                .collection("serviceApp")
                                .doc("appData")
                                .collection("admins") // <-- your collection path
                                .doc(uid)
                                .set(adminData);

                            Get.snackbar(
                              "Success",
                              "Admin profile created successfully!",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            Get.to(() => SubscriptionScreen(
                              adminName: _nameController.text.trim(),
                              adminId: uid,
                              adminNumber: _numberController.text.trim(),
                            ));

                            // Optional: Clear the form
                            _formKey.currentState!.reset();
                            setState(() {
                              _selectedWorkType = null;
                              _selectedCountry = null;
                              _selectedEmployees = null;
                              _imageFile = null;
                            });
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Failed to save admin: $e",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Text Field
  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      TextInputType type, [
        VoidCallback? onTap,
        bool readOnly = false,
      ]) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400)),
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

  // Dropdown Field
  Widget _buildDropdown(
      String label, {
        required List<String> items,
        required String? selectedValue,
        required ValueChanged<String?> onChanged,
        IconData? icon,
      }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null ? 'Select $label' : null,
    );
  }
}
