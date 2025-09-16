//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:app/feature/User/home/presentation/widget/service_details.dart';
//
// class SearchScreen extends StatefulWidget {
//   final String initialCategory;
//
//   const SearchScreen({super.key, this.initialCategory = "All"});
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   late String selectedCategory;
//   String searchQuery = "";
//   bool isLoading = true;
//   Timer? _debounce;
//
//   List<Map<String, dynamic>> jobs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     selectedCategory = widget.initialCategory;
//     fetchJobs();
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   // Fetch jobs from all admins
//   Future<void> fetchJobs() async {
//     setState(() => isLoading = true);
//
//     List<Map<String, dynamic>> allJobs = [];
//
//     final adminSnapshot = await FirebaseFirestore.instance
//         .collection("serviceApp")
//         .doc("appData")
//         .collection("admins")
//         .get();
//
//     for (var adminDoc in adminSnapshot.docs) {
//       final jobSnapshot = await FirebaseFirestore.instance
//           .collection("serviceApp")
//           .doc("appData")
//           .collection("admins")
//           .doc(adminDoc.id)
//           .collection("jobs")
//           .orderBy("createdAt", descending: true)
//           .get();
//
//       for (var jobDoc in jobSnapshot.docs) {
//         final jobData = jobDoc.data();
//         jobData['id'] = jobDoc.id;
//         allJobs.add(jobData);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         jobs = allJobs;
//         isLoading = false;
//       });
//     }
//   }
//
//   // Debounce search input
//   void _onSearchChanged(String value) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       setState(() => searchQuery = value);
//     });
//   }
//
//   // Filter jobs by category & search
//   List<Map<String, dynamic>> get filteredJobs {
//     return jobs.where((job) {
//       final matchesCategory = selectedCategory == "All" || (job["category"] ?? "") == selectedCategory;
//       final matchesSearch = (job["post"] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase());
//       return matchesCategory && matchesSearch;
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Extract unique categories
//     final categories = [
//       "All",
//       ...{for (var job in jobs) (job['category'] ?? '').toString()}..removeWhere((c) => c.isEmpty),
//     ];
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔍 Search bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.search, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextField(
//                               onChanged: _onSearchChanged,
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "Search your needs here",
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.tune, color: Colors.white),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Categories filter
//               SizedBox(
//                 height: 40,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: categories.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 8),
//                   itemBuilder: (context, index) {
//                     bool isSelected = categories[index] == selectedCategory;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedCategory = categories[index];
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.deepPurple : Colors.transparent,
//                           border: Border.all(color: Colors.deepPurple, width: 1.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Center(
//                           child: Text(
//                             categories[index],
//                             style: TextStyle(
//                               color: isSelected ? Colors.white : Colors.deepPurple,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Job cards with shimmer loader
//               Expanded(
//                 child: isLoading
//                     ? GridView.builder(
//                   itemCount: 4,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 0.8,
//                   ),
//                   itemBuilder: (_, __) => _buildSkeletonCard(),
//                 )
//                     : filteredJobs.isEmpty
//                     ? const Center(child: Text("No jobs available"))
//                     : GridView.builder(
//                   key: ValueKey(filteredJobs.length),
//                   itemCount: filteredJobs.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 0.8,
//                   ),
//                   itemBuilder: (context, index) {
//                     final job = filteredJobs[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ServiceDetailsScreen(service: job),
//                           ),
//                         );
//                       },
//                       child: _buildJobCard(job),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Job card widget
//   Widget _buildJobCard(Map<String, dynamic> job) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: job["imageUrl"] != null
//                 ? Image.network(job["imageUrl"], height: 160, width: double.infinity, fit: BoxFit.cover)
//                 : Container(
//               height: 160,
//               color: Colors.grey[300],
//               child: const Icon(Icons.broken_image, color: Colors.grey),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(job["post"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 4),
//                 Text("\$${job["price"] ?? ''}", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(job["location"] ?? "", style: TextStyle(color: Colors.grey[600], fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Shimmer skeleton loader
//   Widget _buildSkeletonCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(height: 160, width: double.infinity, color: Colors.grey),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Container(height: 14, width: 100, color: Colors.grey),
//                   const SizedBox(height: 8),
//                   Container(height: 14, width: 50, color: Colors.grey),
//                   const SizedBox(height: 8),
//                   Container(height: 10, width: 80, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/feature/User/home/presentation/widget/service_details.dart';

class SearchScreen extends StatefulWidget {
  final String initialCategory;

  const SearchScreen({super.key, this.initialCategory = "All"});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String selectedCategory;
  String searchQuery = "";
  bool isLoading = true;
  Timer? _debounce;

  List<Map<String, dynamic>> jobs = [];
  StreamSubscription? jobSubscription;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    listenJobsRealtime();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    jobSubscription?.cancel();
    super.dispose();
  }

  // Listen jobs in real-time from all admins
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

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => searchQuery = value);
    });
  }

  List<Map<String, dynamic>> get filteredJobs {
    return jobs.where((job) {
      final matchesCategory = selectedCategory == "All" || (job["category"] ?? "") == selectedCategory;
      final matchesSearch = (job["post"] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      "All",
      ...{for (var job in jobs) (job['category'] ?? '').toString()}..removeWhere((c) => c.isEmpty),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search your needs here",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categories filter
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    bool isSelected = categories[index] == selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = categories[index]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : Colors.transparent,
                          border: Border.all(color: Colors.deepPurple, width: 1.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Job cards
              Expanded(
                child: isLoading
                    ? GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, __) => _buildSkeletonCard(),
                )
                    : filteredJobs.isEmpty
                    ? const Center(child: Text("No jobs available"))
                    : GridView.builder(
                  key: ValueKey(filteredJobs.length),
                  itemCount: filteredJobs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(service: job, adminId: job['adminId'],),
                          ),
                        );
                      },
                      child: _buildJobCard(job),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
              child: job["imageUrl"] != null
                  ? Image.network(
                job["imageUrl"],
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job["post"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${job["price"] ?? ''}",
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on,color: Colors.red,),
                    Text(
                      job["location"] ?? "",
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildJobCard(Map<String, dynamic> job) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ClipRRect(
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
  //           child: job["imageUrl"] != null
  //               ? Image.network(job["imageUrl"], height: 160, width: double.infinity, fit: BoxFit.cover)
  //               : Container(
  //             height: 120,
  //             color: Colors.grey[300],
  //             child: const Icon(Icons.broken_image, color: Colors.grey),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(job["post"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
  //               const SizedBox(height: 4),
  //               Text("\$${job["price"] ?? ''}", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
  //               const SizedBox(height: 4),
  //               Text(job["location"] ?? "", style: TextStyle(color: Colors.grey[600], fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 160, width: double.infinity, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(height: 14, width: 100, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 50, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 80, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
