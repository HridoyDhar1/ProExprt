//
// import 'package:app/core/widget/custom_button.dart';
// import 'package:app/feature/Admin/chat/presentation/screen/chat_list.dart';
// import 'package:app/feature/Admin/service/presentation/screen/service_detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class HomeScreenAdmin extends StatefulWidget {
//   const HomeScreenAdmin({super.key});
//   static const String name = '/home_admin';
//
//   @override
//   State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
// }
//
// class _HomeScreenAdminState extends State<HomeScreenAdmin> {
//   List<Map<String, String>> services = [];
//   List<Map<String, String>> filteredServices = [];
//
//   TextEditingController searchController = TextEditingController();
//
//   String adminName = 'John Doe';
//   String adminLocation = 'Dhaka, Bangladesh';
//   int unreadMessages = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(_filterServices);
//     _fetchAdminData();
//     _fetchServices();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   // ------------------- FIRESTORE -------------------
//   Future<void> _fetchAdminData() async {
//     try {
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         DocumentSnapshot doc = await FirebaseFirestore.instance
//             .collection("serviceApp")
//             .doc("appData")
//             .collection("admins")
//             .doc(uid)
//             .get();
//
//         if (doc.exists) {
//           setState(() {
//             adminName = doc["name"] ?? "No Name";
//             adminLocation = doc["location"] ?? "No Location";
//           });
//         }
//       }
//     } catch (e) {
//       setState(() {
//         adminName = "Error loading";
//         adminLocation = "";
//       });
//       debugPrint("Error fetching admin data: $e");
//     }
//   }
//
//   Future<void> _fetchServices() async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("admins")
//           .doc(uid)
//           .collection("services")
//           .orderBy("createdAt", descending: true)
//           .get();
//
//       services = snapshot.docs.map((doc) {
//         String title = doc["title"];
//         return {"title": title, "asset": _getIconForService(title)};
//       }).toList();
//
//       setState(() => filteredServices = List.from(services));
//     } catch (e) {
//       debugPrint("Error fetching services: $e");
//     }
//   }
//
//   Future<void> _addService(String name) async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     Map<String, String> newService = {"title": name, "asset": _getIconForService(name)};
//
//     // Add to local list
//     setState(() {
//       services.add(newService);
//       _filterServices();
//     });
//
//     // Add to Firestore
//     try {
//       await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("admins")
//           .doc(uid)
//           .collection("services")
//           .add({
//         "title": name,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Service '$name' added successfully")),
//       );
//     } catch (e) {
//       debugPrint("Error saving service: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to save service")),
//       );
//     }
//   }
//
//   Future<void> _deleteService(int index) async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     String serviceTitle = services[index]["title"]!;
//
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("admins")
//           .doc(uid)
//           .collection("services")
//           .where("title", isEqualTo: serviceTitle)
//           .get();
//
//       for (var doc in snapshot.docs) {
//         await doc.reference.delete();
//       }
//
//       setState(() {
//         services.removeAt(index);
//         _filterServices();
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Service deleted"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error deleting service: $e");
//     }
//   }
//
//   // ------------------- SEARCH -------------------
//   void _filterServices() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       filteredServices = query.isEmpty
//           ? List.from(services)
//           : services
//           .where((s) => s["title"]!.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   String _getIconForService(String name) {
//     String lower = name.toLowerCase();
//     if (lower.contains("repair")) return "assets/icons/repair.png";
//     if (lower.contains("clean")) return "assets/icons/cleaner.png";
//     if (lower.contains("electric")) return "assets/icons/electrician.png";
//     if (lower.contains("carpent")) return "assets/icons/carpenter.png";
//     if (lower.contains("house")) return "assets/icons/house.png";
//     if (lower.contains("event")) return "assets/icons/red-carpet.png";
//     return "assets/icons/service.png"; // default
//   }
//
//   // ------------------- UI -------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FE),
//       body: Column(
//         children: [
//           // HEADER WITH GRADIENT
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 80),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Profile Info
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(adminName,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         )),
//                     const SizedBox(height: 6),
//                     Text(adminLocation,
//                         style: const TextStyle(fontSize: 12, color: Colors.white70)),
//                   ],
//                 ),
//                 // Chat Button
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: IconButton(
//                         icon: const Icon(Icons.message, color: Colors.blue),
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => AdminChatListScreen()),
//                         ),
//                       ),
//                     ),
//                     if (unreadMessages > 0)
//                       Positioned(
//                         right: -2,
//                         top: -2,
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             unreadMessages > 9 ? '9+' : '$unreadMessages',
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//
//           // SEARCH BAR
//           Transform.translate(
//             offset: const Offset(0, -30),
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black26.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4))
//                 ],
//               ),
//               child: TextField(
//                 controller: searchController,
//                 decoration: const InputDecoration(
//                   hintText: "Search services...",
//                   border: InputBorder.none,
//                   icon: Icon(Icons.search, color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//
//           // SERVICES GRID
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   ...filteredServices.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     Map<String, String> service = entry.value;
//                     return GestureDetector(
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               ServiceDetailScreen(serviceTitle: service["title"]!),
//                         ),
//                       ),
//                       onDoubleTap: () => _showDeleteDialog(index),
//                       child: serviceCard(service["title"]!, service["asset"]!),
//                     );
//                   }),
//                   GestureDetector(
//                     onTap: _showAddServiceDialog,
//                     child: addServiceCard(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget serviceCard(String title, String assetPath) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(assetPath, height: 50),
//           const SizedBox(height: 10),
//           Text(title,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
//
//   Widget addServiceCard() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blueAccent, style: BorderStyle.solid, width: 1.5),
//         borderRadius: BorderRadius.circular(18),
//         color: Colors.blue.shade50,
//       ),
//       child: const Center(
//         child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
//       ),
//     );
//   }
//
//   void _showAddServiceDialog() {
//     TextEditingController nameController = TextEditingController();
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Add Service",
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: ScaleTransition(
//             scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
//             child: Center(
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.85,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black26.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 8)),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Add New Service",
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           labelText: "Service Name",
//                           filled: true,
//                           fillColor: Colors.grey.shade100,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           prefixIcon: const Icon(Icons.design_services),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text("Cancel", style: TextStyle(fontSize: 16)),
//                           ),
//                           CustomButton(
//                             name: "Save",
//                             width: 120,
//                             height: 45,
//                             color: Colors.black87,
//                             onPressed: () {
//                               if (nameController.text.isNotEmpty) {
//                                 _addService(nameController.text);
//                                 Navigator.pop(context);
//                               }
//                             },
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showDeleteDialog(int index) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Delete Service",
//       pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return Transform.scale(
//           scale: Curves.easeOutBack.transform(animation.value),
//           child: Opacity(
//             opacity: animation.value,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               backgroundColor: Colors.white,
//               title: Row(
//                 children: const [
//                   Icon(Icons.delete_forever, color: Colors.red),
//                   SizedBox(width: 10),
//                   Text("Delete Service", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               content: Text(
//                 "Are you sure you want to delete '${services[index]["title"]}'?",
//                 style: const TextStyle(fontSize: 16),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   ),
//                   onPressed: () {
//                     _deleteService(index);
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Yes, Delete",
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 400),
//     );
//   }
// }
import 'package:app/core/widget/custom_button.dart';
import 'package:app/feature/Admin/chat/presentation/screen/chat_list.dart';
import 'package:app/feature/Admin/service/presentation/screen/service_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});
  static const String name = '/home_admin';

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  TextEditingController searchController = TextEditingController();

  String adminName = 'John Doe';
  String adminLocation = 'Dhaka, Bangladesh';
  int unreadMessages = 0;

  String? uid;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    uid = FirebaseAuth.instance.currentUser?.uid;
    _fetchAdminData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  Future<void> _fetchAdminData() async {
    if (uid == null) return;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins")
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() {
          adminName = doc["name"] ?? "No Name";
          adminLocation = doc["location"] ?? "No Location";
        });
      }
    } catch (e) {
      debugPrint("Error fetching admin data: $e");
    }
  }

  String _getIconForService(String name) {
    String lower = name.toLowerCase();
    if (lower.contains("repair")) return "assets/icons/repair.png";
    if (lower.contains("clean")) return "assets/icons/cleaner.png";
    if (lower.contains("electric")) return "assets/icons/electrician.png";
    if (lower.contains("carpent")) return "assets/icons/carpenter.png";
    if (lower.contains("house")) return "assets/icons/house.png";
    if (lower.contains("event")) return "assets/icons/red-carpet.png";
    return "assets/icons/service.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 80),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(adminName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(adminLocation,
                        style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
                // Chat button
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.message, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminChatListScreen()),
                        ),
                      ),
                    ),
                    if (unreadMessages > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadMessages > 9 ? '9+' : '$unreadMessages',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),

          // SEARCH BAR
          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search services...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          // SERVICES GRID (STREAMBUILDER)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                onRefresh: () async {
                  // Force Firestore to reload the snapshot
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("serviceApp")
                      .doc("appData")
                      .collection("admins")
                      .doc(uid)
                      .collection("services")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No services added yet"));
                    }

                    List<Map<String, String>> allServices = snapshot.data!.docs.map((doc) {
                      String title = doc["title"];
                      return {"title": title, "asset": _getIconForService(title)};
                    }).toList();

                    // Apply search filter
                    final filtered = searchController.text.isEmpty
                        ? allServices
                        : allServices
                        .where((s) => s["title"]!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                        .toList();

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        ...filtered.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> service = entry.value;
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ServiceDetailScreen(serviceTitle: service["title"]!),
                              ),
                            ),
                            onDoubleTap: () => _showDeleteDialog(service["title"]!),
                            child: serviceCard(service["title"]!, service["asset"]!),
                          );
                        }),
                        GestureDetector(
                          onTap: _showAddServiceDialog,
                          child: addServiceCard(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget serviceCard(String title, String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, height: 50),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget addServiceCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, style: BorderStyle.solid, width: 1.5),
        borderRadius: BorderRadius.circular(18),
        color: Colors.blue.shade50,
      ),
      child: const Center(
        child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
      ),
    );
  }

  void _showAddServiceDialog() {
    TextEditingController nameController = TextEditingController();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add Service",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Add New Service",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Service Name",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.design_services),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                          ),
                          CustomButton(
                            name: "Save",
                            width: 120,
                            height: 45,
                            color: Colors.black87,
                            onPressed: () async {
                              if (nameController.text.isNotEmpty) {
                                await FirebaseFirestore.instance
                                    .collection("serviceApp")
                                    .doc("appData")
                                    .collection("admins")
                                    .doc(uid)
                                    .collection("services")
                                    .add({
                                  "title": nameController.text,
                                  "createdAt": FieldValue.serverTimestamp(),
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String title) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Delete Service",
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(
            opacity: animation.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                children: const [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Delete Service", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                "Are you sure you want to delete '$title'?",
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    final snapshot = await FirebaseFirestore.instance
                        .collection("serviceApp")
                        .doc("appData")
                        .collection("admins")
                        .doc(uid)
                        .collection("services")
                        .where("title", isEqualTo: title)
                        .get();
                    for (var doc in snapshot.docs) {
                      await doc.reference.delete();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Yes, Delete",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
