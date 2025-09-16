import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
import 'package:app/core/widget/map_picker.dart';

class AdminController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final locationController = TextEditingController();

  Rx<String?> selectedWorkType = Rx<String?>(null);
  Rx<String?> selectedCountry = Rx<String?>(null);
  Rx<String?> selectedEmployees = Rx<String?>(null);

  Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final List<AdminModel> localAdmins = <AdminModel>[].obs;

  // Pick image from gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // Pick location from map
  Future<void> pickLocation(BuildContext context) async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MapPickerScreen()),
    );

    if (pickedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pickedLocation.latitude,
        pickedLocation.longitude,
      );
      Placemark place = placemarks[0];
      locationController.text =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  }

  // Save Admin locally
  void saveAdmin() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        numberController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedWorkType.value == null ||
        selectedCountry.value == null ||
        selectedEmployees.value == null) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    final newAdmin = AdminModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'local_user_123',
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      number: numberController.text.trim(),
      location: locationController.text.trim(),
      workType: selectedWorkType.value!,
      country: selectedCountry.value!,
      employees: selectedEmployees.value!,
      imageUrl: imageFile.value?.path,
    );

    localAdmins.add(newAdmin);

    // Clear form
    nameController.clear();
    emailController.clear();
    numberController.clear();
    locationController.clear();
    selectedWorkType.value = null;
    selectedCountry.value = null;
    selectedEmployees.value = null;
    imageFile.value = null;

    Get.snackbar("Success", "Admin Created Locally!");
  }
}
