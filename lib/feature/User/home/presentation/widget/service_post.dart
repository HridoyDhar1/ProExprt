import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
import 'package:app/feature/User/company/presentation/screen/company_details.dart';
import 'package:flutter/material.dart';


class ServicePostsScreen extends StatefulWidget {
  final String serviceName;
  const ServicePostsScreen({super.key, required this.serviceName});

  @override
  State<ServicePostsScreen> createState() => _ServicePostsScreenState();
}

class _ServicePostsScreenState extends State<ServicePostsScreen> {
  List<AdminModel> admins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  // Mock data instead of Firebase
  Future<void> fetchAdmins() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    admins = [
      AdminModel(
        userId: '1',
        name: 'John Doe',
        email: 'john@example.com',
        number: '+123456789',
        location: 'New York',
        workType: 'Electrical',
        employees: '10',
        country: 'USA',
        imageUrl: '', // can use Network URL if available
      ),
      AdminModel(
        userId: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        number: '+987654321',
        location: 'Los Angeles',
        workType: 'Plumbing',
        employees: '5',
        country: 'USA',
        imageUrl: '',
      ),
      // Add more mock admins here
    ];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (admins.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No Companies Found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Center(
          child: Text(widget.serviceName,
              style: const TextStyle(color: Colors.black87)),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: admins.length,
        itemBuilder: (context, index) {
          final admin = admins[index];

          return GestureDetector(
            onTap: () {
              // Navigate to detailed company profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompanyProfileDetails(admin: admin),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Image + Name + Verified + Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: admin.imageUrl != null &&
                                admin.imageUrl!.isNotEmpty
                            ? NetworkImage(admin.imageUrl!)
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name & verified
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    admin.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.verified,
                                    size: 20, color: Colors.black),
                              ],
                            ),
                            // Rating placeholder
                            Row(
                              children: const [
                                Icon(Icons.star,
                                    color: Colors.black87, size: 16),
                                SizedBox(width: 4),
                                Text("4.7 (115 Reviews)",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),

                  // Location & Status
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${admin.location} • Available",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Email & Number
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          admin.email,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        admin.number,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Work type & Employees
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 4),
                      Text('${admin.workType} • ${admin.employees} Employees'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
