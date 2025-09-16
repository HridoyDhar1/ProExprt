//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../core/widget/custom_button.dart';
//
// import '../../../search/presentation/widget/order_details.dart';
//
//
// class ServiceDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> service;
//
//   const ServiceDetailsScreen({super.key, required this.service});
//
//   static const String name = '/service';
//
//   @override
//   State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
// }
//
// class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//
//   // Mock provider data (instead of Firestore)
//   Map<String, dynamic>? providerData;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProvider();
//   }
//
//   // Fake provider data fetch
//   Future<void> _fetchProvider() async {
//     await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
//     setState(() {
//       providerData = {
//
//       };
//     });
//   }
//
//   // Pick Date
//   Future<void> pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//     if (date != null) setState(() => selectedDate = date);
//   }
//
//   // Pick Time
//   Future<void> pickTime() async {
//     TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time != null) setState(() => selectedTime = time);
//   }
//
//   // Local mock chat
//   Future<void> _openChat() async {
//     Get.snackbar(
//       "Chat",
//       "Opening chat with ${providerData?["name"] ?? "Service Provider"}",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.teal,
//       colorText: Colors.white,
//     );
//   }
//
//   // Local mock order
//   Future<void> _placeOrder() async {
//     if (selectedDate == null || selectedTime == null) {
//       Get.snackbar(
//         "Error",
//         "Please select date and time before booking",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BookingConfirmationScreen(
//           service: widget.service,
//           selectedDate: selectedDate,
//           selectedTime: selectedTime,
//         ),
//       ),
//     );
//
//     Get.snackbar(
//       "Success",
//       "Order placed successfully (mock)!",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final job = widget.service;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(bottom: 80),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Service Image
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//               child: job["imageUrl"] != null
//                   ? Image.network(
//                 job["imageUrl"],
//                 width: double.infinity,
//                 height: 300,
//                 fit: BoxFit.cover,
//               )
//                   : Container(
//                 height: 300,
//                 width: double.infinity,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.broken_image, size: 50),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Name & Price
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           job["post"] ?? "Untitled Service",
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         "\$${job["price"] ?? '0'}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Location
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on,
//                           color: Colors.redAccent, size: 18),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           job["location"] ?? "No location provided",
//                           style: TextStyle(
//                               fontSize: 14, color: Colors.grey[700]),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Date & Time Picker
//                   const Text("Select Date & Time",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             minimumSize: const Size(100, 50),
//                             backgroundColor: Colors.grey,
//                           ),
//                           icon: const Icon(Icons.calendar_today,
//                               color: Colors.white),
//                           label: Text(
//                             selectedDate == null
//                                 ? "Pick Date"
//                                 : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           onPressed: pickDate,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             minimumSize: const Size(100, 50),
//                             backgroundColor: Colors.black87,
//                           ),
//                           icon:
//                           const Icon(Icons.access_time, color: Colors.white),
//                           label: Text(
//                             selectedTime == null
//                                 ? "Pick Time"
//                                 : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           onPressed: pickTime,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Service Provider Section
//                   const Text("Service Provider",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 10),
//
//                   providerData == null
//                       ? const Center(child: CircularProgressIndicator())
//                       : GestureDetector(
//                     onTap: () {
//
//
//
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: Colors.teal.withOpacity(0.3), width: 1),
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.grey[200],
//                             child: ClipOval(
//                               child: (providerData!["profileImage"] !=
//                                   null &&
//                                   providerData!["profileImage"]
//                                       .toString()
//                                       .isNotEmpty)
//                                   ? Image.network(
//                                 providerData!["profileImage"],
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               )
//                                   : Image.asset(
//                                 "assets/images/default_avatar.png",
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   providerData!["name"] ??
//                                       "Service Provider",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 if (providerData!["email"] != null)
//                                   Text(
//                                     providerData!["email"],
//                                     style: TextStyle(
//                                         color: Colors.grey[700],
//                                         fontSize: 14),
//                                   ),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: const [
//                                     Icon(Icons.verified,
//                                         color: Colors.teal, size: 16),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "Verified Provider",
//                                       style: TextStyle(
//                                           color: Colors.teal, fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Icon(Icons.arrow_forward_ios,
//                               size: 16, color: Colors.teal),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Map placeholder
//                   const Text("Service Location",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.grey[300],
//                       image: const DecorationImage(
//                         image: AssetImage("assets/images/map_placeholder.png"),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // Bottom Buttons
//       bottomSheet: Container(
//         padding: const EdgeInsets.all(16),
//         color: Colors.white,
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.message, color: Colors.teal),
//                 label: const Text("Message",
//                     style: TextStyle(color: Colors.teal)),
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(100, 40),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   side: const BorderSide(color: Colors.teal),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: _openChat,
//               ),
//             ),
//             const SizedBox(width: 8),
//             CustomButton(
//               name: "Order",
//               width: 200,
//               height: 50,
//               color: Colors.teal,
//               onPressed: _placeOrder,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/widget/custom_button.dart';
import '../../../search/presentation/widget/order_details.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final String? adminId; // admin who posted the service

  const ServiceDetailsScreen({super.key, required this.service,  this.adminId});

  static const String name = '/service';

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Map<String, dynamic>? providerData;

  @override
  void initState() {
    super.initState();
    _fetchProvider();
  }

  Future<void> _fetchProvider() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins")
          .doc(widget.adminId)
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          providerData = doc.data();
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch provider: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void _openChat() {
    Get.snackbar(
      "Chat",
      "Opening chat with ${providerData?["name"] ?? "Service Provider"}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

  void _placeOrder() {
    if (selectedDate == null || selectedTime == null) {
      Get.snackbar(
        "Error",
        "Please select date and time before booking",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          service: widget.service,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
        ),
      ),
    );

    Get.snackbar(
      "Success",
      "Order placed successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: service["imageUrl"] != null
                  ? Image.network(
                service["imageUrl"],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service["post"] ?? "Untitled Service",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${service["price"] ?? '0'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.redAccent, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service["location"] ?? "No location provided",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date & Time Picker
                  const Text("Select Date & Time",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(100, 50),
                            backgroundColor: Colors.grey,
                          ),
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.white),
                          label: Text(
                            selectedDate == null
                                ? "Pick Date"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: pickDate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(100, 50),
                            backgroundColor: Colors.black87,
                          ),
                          icon:
                          const Icon(Icons.access_time, color: Colors.white),
                          label: Text(
                            selectedTime == null
                                ? "Pick Time"
                                : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Service Provider Info
                  const Text("Service Provider",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),

                  providerData == null
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                    onTap: _openChat,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.teal.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: (providerData!["imageUrl"] != null &&
                                  providerData!["imageUrl"]
                                      .toString()
                                      .isNotEmpty)
                                  ? Image.network(
                                providerData!["imageUrl"],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                "assets/images/default_avatar.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  providerData!["name"] ?? "Service Provider",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                if (providerData!["email"] != null)
                                  Text(
                                    providerData!["email"],
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14),
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.verified,
                                        color: Colors.teal, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "Verified Provider",
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.teal),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Map placeholder
                  const Text("Service Location",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/map_placeholder.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.message, color: Colors.teal),
                label: const Text("Message",
                    style: TextStyle(color: Colors.teal)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _openChat,
              ),
            ),
            const SizedBox(width: 8),
            CustomButton(
              name: "Order",
              width: 200,
              height: 50,
              color: Colors.teal,
              onPressed: _placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}
