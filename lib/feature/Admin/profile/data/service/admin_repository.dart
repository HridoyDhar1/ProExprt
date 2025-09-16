import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/admin_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  Future<String> uploadImage(File? file, String adminId) async {
    if (file == null) return '';
    final shardId = adminId.hashCode % 10; // shard calculation
    final ref = _storage.ref().child('admins_images/$shardId/$adminId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Save admin to Firestore with sharding and batch write
  Future<void> saveAdmin(AdminModel admin) async {
    final shardId = admin.id.hashCode % 10; // shard calculation
    final adminRef = _firestore.collection('admins').doc('${shardId}_${admin.id}');
    final summaryRef = _firestore.collection('admin_summary').doc('${shardId}_${admin.id}');

    WriteBatch batch = _firestore.batch();
    batch.set(adminRef, admin.toMap());
    batch.set(summaryRef, admin.toSummaryMap());

    int retries = 0;
    while (retries < 3) {
      try {
        await batch.commit();
        break;
      } catch (e) {
        retries++;
        await Future.delayed(Duration(seconds: 2 * retries));
        if (retries == 3) rethrow;
      }
    }
  }
}
