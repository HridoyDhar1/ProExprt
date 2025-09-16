import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const int shardCount = 10; // Number of shards

  // Upload job image
  Future<String?> uploadImage(File? imageFile, String jobId) async {
    if (imageFile == null) return null;
    final ref = _storage.ref().child('job_images/$jobId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Save job to sharded collection
  Future<void> saveJob(Map<String, dynamic> jobData) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw 'User not logged in';

    final shardId = userId.hashCode % shardCount;
    final jobId = '${shardId}_${DateTime.now().millisecondsSinceEpoch}';
    jobData['id'] = jobId;
    jobData['userId'] = userId;
    jobData['shardId'] = shardId;
    jobData['createdAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection('jobs_shards')
        .doc('shard_$shardId')
        .collection('jobs')
        .doc(jobId)
        .set(jobData);
  }

  // Fetch all jobs across shards
  Stream<List<Map<String, dynamic>>> getAllJobs() {
    List<Stream<List<Map<String, dynamic>>>> streams = [];
    for (int i = 0; i < shardCount; i++) {
      final stream = _firestore
          .collection('jobs_shards')
          .doc('shard_$i')
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
      streams.add(stream);
    }

    return Stream<List<Map<String, dynamic>>>.multi((controller) {
      List<List<Map<String, dynamic>>> shardData = List.generate(shardCount, (_) => []);

      for (int i = 0; i < streams.length; i++) {
        streams[i].listen((data) {
          shardData[i] = data;
          controller.add(shardData.expand((e) => e).toList());
        });
      }
    });
  }

  // Delete job
  Future<void> deleteJob(String jobId, int shardId) async {
    await _firestore
        .collection('jobs_shards')
        .doc('shard_$shardId')
        .collection('jobs')
        .doc(jobId)
        .delete();
  }
}
