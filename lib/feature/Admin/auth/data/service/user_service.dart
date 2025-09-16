import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

import '../model/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Top-level collections
  static const String usersCollection = 'users';
  static const String adminsCollection = 'admins';

  /// Number of shards to use for distributing writes/reads (adjust based on scale).
  /// For millions of users, choose e.g. 100 or 256 shards depending on query patterns.
  final int shardCount;

  UserService({this.shardCount = 128});

  /// compute shard id from uid (stable)
  int computeShard(String uid) {
    // simple deterministic hash to integer
    final bytes = utf8.encode(uid);
    int hash = 0;
    for (var b in bytes) {
      hash = (hash * 31 + b) & 0x7fffffff;
    }
    return hash % shardCount;
  }

  /// Create user doc in top-level collection with shard field and server timestamp.
  /// Use batched write so later you can add other docs atomically.
  Future<void> createUser(AppUser user) async {
    final col = (user.role == 'Admin') ? adminsCollection : usersCollection;
    final docRef = _firestore.collection(col).doc(user.uid);

    WriteBatch batch = _firestore.batch();

    batch.set(docRef, {
      ...user.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Example: if you want to create a public profile or lightweight record for fast queries,
    // add a small duplicate doc in "userSummaries" collection (optional).
    // final summaryRef = _firestore.collection('userSummaries').doc(user.uid);
    // batch.set(summaryRef, { 'uid': user.uid, 'name': user.name, 'shard': user.shard });

    // Commit with retry/backoff
    await _commitWithRetry(batch);
  }

  Future<void> _commitWithRetry(WriteBatch batch, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        await batch.commit();
        return;
      } catch (e) {
        attempt++;
        if (attempt > retries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }
    }
  }

  /// Read user by uid
  Future<AppUser?> getUser(String uid, {String role = 'User'}) async {
    final col = role == 'Admin' ? adminsCollection : usersCollection;
    final snap = await _firestore.collection(col).doc(uid).get();
    if (!snap.exists) return null;
    final data = snap.data()!;
    return AppUser.fromMap({
      ...data,
      'createdAt': data['createdAt'] ?? DateTime.now(),
    });
  }

  /// Query example: get users from a shard (used for scaling queries)
  Future<List<AppUser>> getUsersFromShard(int shardId, {int limit = 50}) async {
    final qs = await _firestore
        .collection(usersCollection)
        .where('shard', isEqualTo: shardId)
        .limit(limit)
        .get();
    return qs.docs.map((d) => AppUser.fromMap({...d.data(), 'createdAt': d['createdAt']})).toList();
  }
}
