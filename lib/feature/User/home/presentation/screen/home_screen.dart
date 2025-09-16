//
// import 'package:flutter/material.dart';
//
// import '../../../search/presentation/screen/search_screen.dart';
// import '../widget/service_card.dart';
// import '../widget/service_category.dart';
// import '../widget/service_details.dart';
//
// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});
//
//   static const String name = '/user_home';
//
//   @override
//   State<UserHomeScreen> createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   final PageController _pageController = PageController();
//
//   // ✅ Local static job list (replace with API later if needed)
//   final List<Map<String, dynamic>> jobs = [
//     {
//       "id": "1",
//       "post": "AC Repair",
//       "price": "100",
//       "imageUrl": "https://via.placeholder.com/150",
//       "category": "Home Services",
//     },
//     {
//       "id": "2",
//       "post": "Plumbing",
//       "price": "80",
//       "imageUrl": "https://via.placeholder.com/150",
//       "category": "Home Services",
//     },
//     {
//       "id": "3",
//       "post": "Car Wash",
//       "price": "50",
//       "imageUrl": "https://via.placeholder.com/150",
//       "category": "Automotive",
//     },
//     {
//       "id": "4",
//       "post": "Haircut",
//       "price": "20",
//       "imageUrl": "https://via.placeholder.com/150",
//       "category": "Personal Care",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Extract unique categories
//     final categories = [
//       ...{
//         for (var job in jobs) (job['category'] ?? '').toString()
//       }..removeWhere((c) => c.isEmpty),
//     ];
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           children: [
//             _buildTopSection(),
//             const SizedBox(height: 15),
//             _buildSpecialOffers(),
//             const SizedBox(height: 20),
//             _buildServices(),
//             const SizedBox(height: 15),
//
//             // ✅ Dynamically build category sections
//             for (var category in categories) ...[
//               _buildSectionTitle(category),
//               _buildHorizontalList(
//                 jobs.where((job) => job['category'] == category).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Top Purple Section (location + search + notification)
//   Widget _buildTopSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF6A1B9A), // purple background
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.orange),
//               const SizedBox(width: 8),
//               const Text(
//                 "New York, USA",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//               const Icon(Icons.arrow_drop_down, color: Colors.white),
//               const Spacer(),
//               Stack(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.notifications, color: Colors.white),
//                     onPressed: () {},
//                   ),
//                   Positioned(
//                     right: 10,
//                     top: 10,
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(Icons.search, color: Colors.grey),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: "Search",
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.tune, color: Colors.grey),
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Special Offers Section (carousel + dots)
//   Widget _buildSpecialOffers() {
//     final offers = [
//       "Get Special Offer Up to 20%",
//       "Discount on Oil Change",
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle("Special Offers"),
//         SizedBox(
//           height: 160,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: offers.length,
//             itemBuilder: (context, index) {
//               return _offerCard(offers[index]);
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//         Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               offers.length,
//                   (index) => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _offerCard(String text) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text("Claim"),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Services Section (keep ServiceCategoryGrid)
//   Widget _buildServices() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle("Services"),
//         ServiceCategoryGrid(), // ✅ keep your existing widget
//       ],
//     );
//   }
//
//   /// 🔹 Section Title with "See all"
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SearchScreen(initialCategory: title), // ✅ pass category
//                 ),
//               );
//             },
//             child: Text(
//               "See all",
//               style: TextStyle(fontSize: 14, color: Colors.blue[700]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Horizontal List of Jobs
//   Widget _buildHorizontalList(List<Map<String, dynamic>> jobs) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: jobs.length,
//         itemBuilder: (context, index) {
//           final job = jobs[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ServiceDetailsScreen(service: job),
//                 ),
//               );
//             },
//             child: HomeServiceCard(
//               title: job['post'] ?? "No Title",
//               price: "\$${job['price'] ?? '0'}",
//               imageUrl: job['imageUrl'] ??
//                   "https://via.placeholder.com/150", // ✅ fallback image
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../search/presentation/screen/search_screen.dart';
import '../widget/service_card.dart';
import '../widget/service_category.dart';
import '../widget/service_details.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  static const String name = '/user_home';

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final PageController _pageController = PageController();
  bool isLoading = true;
  String userLocation = "Loading...";

  List<Map<String, dynamic>> jobs = [];
  StreamSubscription? jobSubscription;
  StreamSubscription? userSubscription;
  @override
  void initState() {
    super.initState();
    listenJobsRealtime();
    listenUserLocationRealtime();
  }

  @override
  void dispose() {
    jobSubscription?.cancel();
    userSubscription?.cancel();
    super.dispose();
  }
  void listenUserLocationRealtime() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userSubscription = FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            userLocation = snapshot.data()?['location'] ?? "No Location";
          });
        }
      });
    }
  }

  // Listen all jobs from all admins in real-time
  void listenJobsRealtime() {
    jobSubscription = FirebaseFirestore.instance
        .collection("serviceApp")
        .doc("appData")
        .collection("admins")
        .snapshots()
        .listen((adminSnapshot) {
      for (var adminDoc in adminSnapshot.docs) {
        FirebaseFirestore.instance
            .collection("serviceApp")
            .doc("appData")
            .collection("admins")
            .doc(adminDoc.id)
            .collection("jobs")
            .orderBy("createdAt", descending: true)
            .snapshots()
            .listen((jobSnapshot) {
          List<Map<String, dynamic>> allJobs = [];
          for (var jobDoc in jobSnapshot.docs) {
            final jobData = jobDoc.data();
            jobData['id'] = jobDoc.id;
            allJobs.add(jobData);
          }
          if (mounted) {
            setState(() {
              jobs = allJobs;
              isLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      ...{for (var job in jobs) (job['category'] ?? '').toString()}..removeWhere((c) => c.isEmpty),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            _buildTopSection(),
            const SizedBox(height: 15),
            _buildSpecialOffers(),
            const SizedBox(height: 20),
            _buildServices(),
            const SizedBox(height: 15),
            // Dynamic category sections
            for (var category in categories) ...[
              _buildSectionTitle(category),
              _buildHorizontalList(
                jobs.where((job) => job['category'] == category).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF6A1B9A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.orange),
              const SizedBox(width: 8),
       Text( userLocation, style: TextStyle(color: Colors.white, fontSize: 10)),

              const Spacer(),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffers() {
    final offers = ["Get Special Offer Up to 20%", "Discount on Oil Change"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Special Offers"),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            itemBuilder: (context, index) => _offerCard(offers[index]),
          ),
        ),
      ],
    );
  }

  Widget _offerCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Claim"),
          )
        ],
      ),
    );
  }

  Widget _buildServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Services"),
        ServiceCategoryGrid(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(initialCategory: title),
                ),
              );
            },
            child: Text("See all", style: TextStyle(fontSize: 14, color: Colors.blue[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, dynamic>> jobs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: job)),
              );
            },
            child: HomeServiceCard(
              title: job['post'] ?? "No Title",
              price: "\$${job['price'] ?? '0'}",
              imageUrl: job['imageUrl'] ?? "https://via.placeholder.com/150",
            ),
          );
        },
      ),
    );
  }
}
