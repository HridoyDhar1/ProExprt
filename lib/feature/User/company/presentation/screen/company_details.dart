// import 'package:app/core/widget/contact_screen.dart';
// import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CompanyProfileDetails extends StatelessWidget {
//   final AdminModel admin;
//
//   const CompanyProfileDetails({super.key, required this.admin});
//
//   static const String routeName = '/company_profile';
//
//   // Removed Firebase chat logic, replaced with simple snackbar
//   void _openChat(BuildContext context) {
//     Get.snackbar(
//       "Info",
//       "Chat feature is currently offline.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.grey[800],
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 50),
//
//             /// Profile Header
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       /// Profile Image
//                       CircleAvatar(
//                         radius: 80,
//                         backgroundColor: Colors.grey[200],
//                         child: ClipOval(
//                           child: admin.imageUrl != null &&
//                                   admin.imageUrl!.isNotEmpty
//                               ? FadeInImage.assetNetwork(
//                                   placeholder:
//                                       "assets/images/default_avatar.png",
//                                   image: admin.imageUrl!,
//                                   fit: BoxFit.cover,
//                                   width: 150,
//                                   height: 150,
//                                 )
//                               : Image.asset(
//                                   "assets/images/default_avatar.png",
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Rating placeholder
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.star, size: 25, color: Colors.amber),
//                           SizedBox(width: 4),
//                           Text("4.7", style: TextStyle(fontSize: 14)),
//                           SizedBox(width: 4),
//                           Text(
//                             "(115 Reviews)",
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Name + Verified
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               admin.name,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Icon(
//                             Icons.verified,
//                             size: 28,
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Location
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on_outlined, size: 16),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               admin.country,
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Text(
//                             " • Available",
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//
//                       // Email
//                       Row(
//                         children: [
//                           const Icon(Icons.email, size: 16),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               admin.email,
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             /// Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () {
//                       _openChat(context);
//                     },
//                     child: const Text(
//                       "Message",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () {
//                       // Navigate to contact screen with admin's contact info
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ContactUsScreen(
//                             adminPhone: admin.number,
//                             adminEmail: admin.email,
//                             adminName: admin.name,
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text("Call"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//
//             /// Company Info
//             const Text(
//               "Company Info",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "About ${admin.name}",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "📍 Location: ${admin.location}\n"
//                   "💼 Work Type: ${admin.workType}\n"
//                   "👥 Employees: ${admin.employees}\n"
//                   "📧 Email: ${admin.email}\n"
//                   "🌍 Country: ${admin.country}\n"
//                   "Number: ${admin.number}",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:app/core/widget/contact_screen.dart';
import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyProfileDetails extends StatelessWidget {
  const CompanyProfileDetails({super.key});

  static const String routeName = '/company_profile';

  /// Fetch currently logged-in admin from Firestore
  Future<AdminModel?> fetchCurrentAdmin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('serviceApp')
        .doc('appData')
        .collection('admins')
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return AdminModel.fromMap(doc.data()!);
  }

  /// Dummy chat function
  void _openChat(BuildContext context) {
    Get.snackbar(
      "Info",
      "Chat feature is currently offline.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminModel?>(
      future: fetchCurrentAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Admin data not found')),
          );
        }

        final admin = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                /// Profile Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Profile Image
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: admin.imageUrl != null &&
                                  admin.imageUrl!.isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                placeholder:
                                "assets/images/default_avatar.png",
                                image: admin.imageUrl!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                                  : Image.asset(
                                "assets/images/default_avatar.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Rating placeholder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.star, size: 25, color: Colors.amber),
                              SizedBox(width: 4),
                              Text("4.7", style: TextStyle(fontSize: 14)),
                              SizedBox(width: 4),
                              Text(
                                "(115 Reviews)",
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Name + Verified
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  admin.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.verified,
                                size: 28,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Location
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  admin.country,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text(
                                " • Available",
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Email
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  admin.email,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          _openChat(context);
                        },
                        child: const Text(
                          "Message",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Navigate to contact screen with admin's contact info
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactUsScreen(
                                adminPhone: admin.number,
                                adminEmail: admin.email,
                                adminName: admin.name,
                              ),
                            ),
                          );
                        },
                        child: const Text("Call"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// Company Info
                const Text(
                  "Company Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About ${admin.name}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "📍 Location: ${admin.location}\n"
                          "💼 Work Type: ${admin.workType}\n"
                          "👥 Employees: ${admin.employees}\n"
                          "📧 Email: ${admin.email}\n"
                          "🌍 Country: ${admin.country}\n"
                          "Number: ${admin.number}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
