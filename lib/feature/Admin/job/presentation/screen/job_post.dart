//
// import 'package:app/feature/Admin/job/presentation/controller/job_post_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:app/core/widget/custom_button.dart';
//
// class JobPostScreen extends StatelessWidget {
//   const JobPostScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(JobPostController());
//
//     void showAddJobDialog() {
//       showGeneralDialog(
//         context: context,
//         barrierDismissible: true,
//         barrierLabel: "Add Job",
//         transitionDuration: const Duration(milliseconds: 500),
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return const SizedBox.shrink();
//         },
//         transitionBuilder: (context, animation, secondaryAnimation, child) {
//           final curvedAnimation = CurvedAnimation(
//             parent: animation,
//             curve: Curves.elasticOut,
//           );
//
//           return FadeTransition(
//             opacity: animation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0, 0.3),
//                 end: Offset.zero,
//               ).animate(curvedAnimation),
//               child: ScaleTransition(
//                 scale: curvedAnimation,
//                 child: Center(
//                   child: Material(
//                     color: Colors.transparent,
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26.withOpacity(0.25),
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               "Add Job Post",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.teal,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Obx(() => GestureDetector(
//                               onTap: controller.pickImage,
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 300),
//                                 height: 160,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.teal.shade200, width: 1.5),
//                                   borderRadius: BorderRadius.circular(12),
//                                   color: Colors.grey.shade100,
//                                 ),
//                                 child: controller.selectedImage.value != null
//                                     ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.file(
//                                     controller.selectedImage.value!,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                                     : Center(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     children: const [
//                                       Icon(Icons.camera_alt,
//                                           size: 40, color: Colors.teal),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         "Tap to select photo",
//                                         style:
//                                         TextStyle(color: Colors.teal),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )),
//                             const SizedBox(height: 16),
//                             _buildTextField(
//                                 controller.postController, "Post", Icons.work),
//                             const SizedBox(height: 12),
//                             _buildTextField(controller.priceController, "Price",
//                                 Icons.attach_money,
//                                 keyboardType: TextInputType.number),
//                             const SizedBox(height: 12),
//                             _buildTextField(
//                                 controller.categoryController, "Category", Icons.category),
//                             const SizedBox(height: 12),
//                             _buildTextField(controller.locationController, "Location",
//                                 Icons.location_on,
//                                 readOnly: true,
//                                 onTap: () => controller.pickLocation(context)),
//                             const SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text(
//                                     "Cancel",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                                 CustomButton(
//                                   name: "Save",
//                                   width: 120,
//                                   height: 45,
//                                   color: Colors.teal,
//
//                                   onPressed: () {
//                                     controller.saveJobPost();
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }
//
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Center(child: Text("Job Posts")),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Obx(() => controller.jobs.isEmpty
//           ? const Center(child: Text("No job posts yet"))
//           : GridView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: controller.jobs.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8,
//           mainAxisSpacing: 8,
//           childAspectRatio: 0.75,
//         ),
//         itemBuilder: (context, index) {
//           final jobData = controller.jobs[index];
//           return _buildJobCard(controller, jobData);
//         },
//       )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showAddJobDialog,
//         backgroundColor: Colors.teal,
//         child: const Icon(Icons.add,color: Colors.white,),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
//       {TextInputType keyboardType = TextInputType.text, bool readOnly = false, VoidCallback? onTap}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       readOnly: readOnly,
//       onTap: onTap,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.teal),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildJobCard(JobPostController controller, Map<String, dynamic> job) {
//     return Container(
//       margin: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: job["imageFile"] != null
//                     ? Image.file(
//                   job["imageFile"],
//                   height: 170,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//                     : Container(
//                   height: 160,
//                   color: Colors.grey[300],
//                   child: Icon(Icons.broken_image, color: Colors.grey[600]),
//                 ),
//               ),
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: GestureDetector(
//                   onTap: () => controller.deleteJob(job["id"]),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.red.withOpacity(0.8),
//                     child: const Icon(Icons.delete, color: Colors.white, size: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(job["post"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 5),
//                 Text("\$${job["price"]}",
//                     style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(job["location"],
//                           style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/job_post_controller.dart';
import 'package:app/core/widget/custom_button.dart';

class JobPostScreen extends StatelessWidget {
  const JobPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobPostController());

    void showAddJobDialog() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Add Job",
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        transitionBuilder: (_, animation, __, ___) {
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.elasticOut);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
                  .animate(curvedAnimation),
              child: ScaleTransition(
                scale: curvedAnimation,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 10))],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Add Job Post",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                            const SizedBox(height: 16),
                            Obx(() => GestureDetector(
                              onTap: controller.pickImage,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.teal.shade200, width: 1.5),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade100,
                                ),
                                child: controller.selectedImage.value != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(controller.selectedImage.value!, fit: BoxFit.cover),
                                )
                                    : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.camera_alt, size: 40, color: Colors.teal),
                                      SizedBox(height: 4),
                                      Text("Tap to select photo", style: TextStyle(color: Colors.teal)),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                            const SizedBox(height: 16),
                            _buildTextField(controller.postController, "Post", Icons.work),
                            const SizedBox(height: 12),
                            _buildTextField(controller.priceController, "Price", Icons.attach_money, keyboardType: TextInputType.number),
                            const SizedBox(height: 12),
                            _buildTextField(controller.categoryController, "Category", Icons.category),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller.locationController,
                              "Location",
                              Icons.location_on,
                              readOnly: true, // user cannot type
                              onTap: () => controller.pickLocation(context), // open map picker
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
                                  color: Colors.teal,
                                  onPressed: () async {
                                    await controller.saveJobPost();
                                    Navigator.pop(context);
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
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Job Posts")),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        // Show shimmer loader if jobs are empty
        if (controller.jobs.isEmpty) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          );
        }

        // Pull-to-refresh grid
        return RefreshIndicator(
          onRefresh: controller.fetchJobs,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.jobs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final job = controller.jobs[index];
              return _buildJobCard(controller, job);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddJobDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text, bool readOnly = false, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildJobCard(JobPostController controller, Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: job["imageUrl"] != null
                    ? Image.network(
                  job["imageUrl"],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: () => controller.deleteJob(job),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red.withOpacity(0.8),
                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job["post"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Text("\$${job["price"]}", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(job["location"], style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
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
}
