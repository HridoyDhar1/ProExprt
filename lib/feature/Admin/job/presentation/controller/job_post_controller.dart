import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../core/widget/map_picker.dart';

class JobPostController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  final picker = ImagePicker();

  final TextEditingController postController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  RxList<Map<String, dynamic>> jobs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> pickLocation(BuildContext context) async {
    // Navigate to Map Picker
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );

    if (result != null) {
      // Automatically fill the location field
      locationController.text = result;
    }
  }



  Future<void> saveJobPost() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String? imageUrl;
    if (selectedImage.value != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("jobPosts/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg");
      await ref.putFile(selectedImage.value!);
      imageUrl = await ref.getDownloadURL();
    }

    final jobData = {
      "post": postController.text,
      "price": priceController.text,
      "category": categoryController.text,
      "location": locationController.text,
      "imageUrl": imageUrl,
      "adminId": uid,
      "createdAt": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("admins")
        .doc(uid)
        .collection("jobs")
        .add(jobData);

    clearFields();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("admins")
        .doc(uid)
        .collection("jobs")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      jobs.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data["id"] = doc.id; // save doc id for deletion
        return data;
      }).toList();
    });
  }

  Future<void> deleteJob(Map<String, dynamic> job) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || job["id"] == null) return;

    await FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("admins")
        .doc(uid)
        .collection("jobs")
        .doc(job["id"])
        .delete();
  }

  void clearFields() {
    postController.clear();
    priceController.clear();
    categoryController.clear();
    locationController.clear();
    selectedImage.value = null;
  }
}
