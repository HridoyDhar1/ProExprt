// import 'package:app/feature/User/profile/presentation/widget/booking_list.dart';
// import 'package:app/feature/User/profile/presentation/widget/edit_profile.dart';
// import 'package:flutter/material.dart';
//
// class UserProfileScreen extends StatelessWidget {
//  UserProfileScreen({Key? key}) : super(key: key);
//   static const String name = '/user_profile';
//
//   // Mock user data
//   final Map<String, dynamic> mockUserData = {
//     "profileImage": "https://via.placeholder.com/150",
//     "name": "John Doe",
//     "email": "johndoe@example.com",
//   };
//
//   Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.15),
//               spreadRadius: 0.5,
//               blurRadius: 0.5,
//               offset: const Offset(0, 0),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: Colors.grey[800], size: 22),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<Map<String, dynamic>> _getUserData() async {
//     // Simulate network or DB delay
//     await Future.delayed(const Duration(milliseconds: 500));
//     return mockUserData;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       body: SafeArea(
//         child: FutureBuilder<Map<String, dynamic>>(
//           future: _getUserData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text("User data not found"));
//             }
//
//             final userData = snapshot.data!;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Column(
//                 children: [
//                   // Profile Picture
//                   CircleAvatar(
//                     radius: 80,
//                     backgroundImage: NetworkImage(
//                       userData["profileImage"] ?? "https://via.placeholder.com/150",
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//
//                   // Name
//                   Text(
//                     userData["name"] ?? "No Name",
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 4),
//
//                   // Email
//                   Text(
//                     userData["email"] ?? "No Email",
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 12),
//
//                   // Edit Profile Button
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditUserProfileScreen(),
//                         ),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.blue),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                     ),
//                     child: const Text(
//                       "Edit Profile",
//                       style: TextStyle(color: Colors.blue, fontSize: 14),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Menu Items
//                   _menuItem(Icons.handshake, "Register as a Partner", onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => BookingListScreen()),
//                     );
//                   }),
//                   _menuItem(Icons.help_outline, "Help Center"),
//                   _menuItem(Icons.share, "Share & Earn"),
//                   _menuItem(Icons.star_border, "Rate us"),
//                   _menuItem(Icons.privacy_tip_outlined, "Privacy Policy"),
//                   _menuItem(Icons.logout, "Logout"),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:app/feature/User/profile/presentation/widget/booking_list.dart';
import 'package:app/feature/User/profile/presentation/widget/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);
  static const String name = '/user_profile';

  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.grey[800], size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection("serviceApp")
        .doc("appData")
        .collection("users")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("User data not found"));
            }

            final userData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // Profile Picture (placeholder if not present)
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      userData["profileImage"] ??
                          "https://via.placeholder.com/150",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    userData["name"] ?? "No Name",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    userData["email"] ?? "No Email",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // Edit Profile Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfileScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Menu Items
                  _menuItem(Icons.handshake, "Register as a Partner", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingListScreen()),
                    );
                  }),
                  _menuItem(Icons.help_outline, "Help Center"),
                  _menuItem(Icons.share, "Share & Earn"),
                  _menuItem(Icons.star_border, "Rate us"),
                  _menuItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                  _menuItem(Icons.logout, "Logout", onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
