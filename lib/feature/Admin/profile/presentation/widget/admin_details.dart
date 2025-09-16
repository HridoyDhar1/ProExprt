// import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
// import 'package:app/feature/Admin/profile/presentation/widget/edit_profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AdminProfileScreen extends StatefulWidget {
//   const AdminProfileScreen({Key? key}) : super(key: key);
//
//   static const String name = '/admin_profile';
//
//   @override
//   State<AdminProfileScreen> createState() => _AdminProfileScreenState();
// }
//
// class _AdminProfileScreenState extends State<AdminProfileScreen> {
//   AdminModel? adminData;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//
//
//   // ------------------ Menu Item Widget ------------------
//   Widget _menuItem(IconData icon, String title, {VoidCallback? onTap, Color? iconColor}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor ?? Colors.blue, size: 22),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ------------------ Logout ------------------
//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Get.offAllNamed("/login"); // Replace with your login route
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//
//     if (uid == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user logged in")),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F6FA),
//       body: SafeArea(
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("serviceApp")
//               .doc("appData")
//               .collection("admins")
//               .doc(uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Center(child: Text("No profile found"));
//             }
//
//             final data = snapshot.data!.data() as Map<String, dynamic>;
//             final adminData = AdminModel.fromMap(data, snapshot.data!.id);
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Profile Picture
//                   Container(
//                     margin: const EdgeInsets.only(top: 30),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 55,
//                       backgroundImage: adminData.imageUrl != null
//                           ? NetworkImage(adminData.imageUrl!)
//                           : const AssetImage("assets/profile_placeholder.png") as ImageProvider,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Name
//                   Text(
//                     adminData.name ?? "No Name",
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 6),
//
//                   // Email
//                   Text(
//                     adminData.email ?? "No Email",
//                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 4),
//
//                   // Location
//                   Text(
//                     adminData.location ?? "No Location",
//                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Edit Profile
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditProfileScreen(adminData: adminData),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       "Edit Profile",
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // Menu Items
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       children: [
//                         _menuItem(Icons.help_outline, "Help Center"),
//                         _menuItem(Icons.share, "Share & Earn"),
//                         _menuItem(Icons.star_border, "Rate us"),
//                         _menuItem(Icons.privacy_tip_outlined, "Privacy Policy"),
//                         _menuItem(Icons.logout, "Logout",
//                             iconColor: Colors.red, onTap: _logout),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:app/feature/Admin/profile/data/model/admin_model.dart';
import 'package:app/feature/Admin/profile/presentation/widget/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  static const String name = '/admin_profile';

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("serviceApp")
              .doc("appData")
              .collection("admins")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No admin profile found."));
            }

            // Convert Firestore data to AdminModel
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final adminData = AdminModel.fromMap(data);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: (adminData.imageUrl != null &&
                          adminData.imageUrl!.isNotEmpty)
                          ? NetworkImage(adminData.imageUrl!)
                          : const AssetImage("assets/profile_placeholder.png")
                      as ImageProvider,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    adminData.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  // Email
                  Text(
                    adminData.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Text(
                    adminData.location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 20),

                  // Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(adminData: adminData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Menu Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _menuItem(Icons.help_outline, "Help Center"),
                        _menuItem(Icons.share, "Share & Earn"),
                        _menuItem(Icons.star_border, "Rate us"),
                        _menuItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                        _menuItem(Icons.logout, "Logout",
                            iconColor: Colors.red, onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.offAllNamed("/login");
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title,
      {VoidCallback? onTap, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.blue, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
