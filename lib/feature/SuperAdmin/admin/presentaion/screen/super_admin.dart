import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminListScreen extends StatelessWidget {
  const AdminListScreen({super.key});
static const String name=
    "/admin_dashboard";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Admins"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection("admins")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No admins found."));
          }

          final admins = snapshot.data!.docs;

          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${admin['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Email: ${admin['email']}"),
                      Text("Number: ${admin['number']}"),
                      Text("Location: ${admin['location']}"),
                      const SizedBox(height: 10),
                      const Text("Subscriptions:", style: TextStyle(fontWeight: FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                        stream: admin.reference.collection("subscriptions").snapshots(),
                        builder: (context, subSnapshot) {
                          if (!subSnapshot.hasData || subSnapshot.data!.docs.isEmpty) {
                            return const Text("No subscriptions");
                          }

                          final subs = subSnapshot.data!.docs;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subs.map((s) {
                              final status = s['status'];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${s['plan']} - ${s['price']} (Bkash: ${s['bkash_number']})",
                                      style: TextStyle(
                                        color: status == 'declined' ? Colors.red : Colors.deepPurple,
                                      ),
                                    ),
                                    if (status == 'pending')
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              s.reference.update({'status': 'accepted'});
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            child: const Text("Accept"),
                                          ),
                                          const SizedBox(width: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              s.reference.update({'status': 'declined'});
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                            child: const Text("Decline"),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
