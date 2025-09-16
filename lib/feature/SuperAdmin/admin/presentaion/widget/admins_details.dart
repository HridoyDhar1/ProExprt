import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
import 'package:flutter/material.dart';



class AdminDetailsPage extends StatelessWidget {
  final String adminId;

  AdminDetailsPage({required this.adminId});

  // Mock data for admins
  final Map<String, AdminModel> _mockAdmins = {

  };

  // Simulate fetching admin profile (replaces Firebase)
  Future<AdminModel?> _getAdminProfile(String adminId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate delay
    return _mockAdmins[adminId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Details')),
      body: FutureBuilder<AdminModel?>(
        future: _getAdminProfile(adminId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final admin = snapshot.data;
          if (admin == null) {
            return const Center(child: Text('Admin not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: admin.imageUrl != null && admin.imageUrl!.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(admin.imageUrl!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                ),
                const SizedBox(height: 20),
                Text('Name: ${admin.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Email: ${admin.email}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Number: ${admin.number}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Location: ${admin.location}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Work Type: ${admin.workType}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Country: ${admin.country}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Employees: ${admin.employees}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
