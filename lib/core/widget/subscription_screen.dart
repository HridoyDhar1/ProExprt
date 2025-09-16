// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../feature/SuperAdmin/admin/presentaion/screen/super_admin.dart';
//
// class SubscriptionScreen extends StatelessWidget {
//   final String? adminName;
//   final String? adminId;
//   final String? adminNumber;
//
//   const SubscriptionScreen({
//     super.key,
//    this.adminName,
//     this.adminId,
//      this.adminNumber,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Subscription Plans'),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Choose the best plan for you',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildPlanCard(context, 'Basic', '\$4.99/mo'),
//                   const SizedBox(height: 16),
//                   _buildPlanCard(context, 'Premium', '\$9.99/mo', isHighlighted: true),
//                   const SizedBox(height: 16),
//                   _buildPlanCard(context, 'Pro', '\$19.99/mo'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlanCard(BuildContext context, String title, String price,
//       {bool isHighlighted = false}) {
//     return GestureDetector(
//       onTap: () => _showPaymentDialog(context, title, price),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isHighlighted ? Colors.deepPurple : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: isHighlighted ? Colors.white : Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               price,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: isHighlighted ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showPaymentDialog(BuildContext context, String plan, String price) {
//     final TextEditingController bkashNumberController = TextEditingController();
//     final TextEditingController transactionIdController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.payment,
//                       size: 50, color: Colors.deepPurple),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Subscribe to $plan',
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField(
//                     controller: bkashNumberController,
//                     label: 'Bkash Number',
//                     icon: Icons.phone_android,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     controller: transactionIdController,
//                     label: 'Bkash Transaction ID',
//                     icon: Icons.lock,
//                   ),
//                   const SizedBox(height: 25),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         String bkashNumber = bkashNumberController.text.trim();
//                         String transactionId = transactionIdController.text.trim();
//                         if (bkashNumber.isEmpty || transactionId.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Please fill all fields')),
//                           );
//                           return;
//                         }
//
//                         // Save subscription info under admin's subcollection
//                         await FirebaseFirestore.instance
//                             .collection("serviceApp")
//                             .doc("appData")
//                             .collection("admins")
//                             .doc(adminId)
//                             .collection("subscriptions")
//                             .add({
//                           'plan': plan,
//                           'price': price,
//                           'bkash_number': bkashNumber,
//                           'transaction_id': transactionId,
//                           'timestamp': FieldValue.serverTimestamp(),
//                           'status': 'pending',
//                         });
//
//                         Navigator.pop(context); // close dialog
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Subscribed to $plan successfully!')),
//                         );
//
//
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         backgroundColor: Colors.deepPurple,
//                       ),
//                       child: Text(
//                         'Pay $price',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTextField(
//       {required TextEditingController controller,
//         required String label,
//         required IconData icon,
//         bool obscureText = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.deepPurple),
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SubscriptionScreen extends StatelessWidget {
  final String? adminName;
  final String? adminId;
  final String? adminNumber;

  const SubscriptionScreen({
    super.key,
    this.adminName,
    this.adminId,
    this.adminNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Choose the best plan for you',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPlanCard(context, 'Basic', '\$4.99/mo'),
                  const SizedBox(height: 16),
                  _buildPlanCard(context, 'Premium', '\$9.99/mo', isHighlighted: true),
                  const SizedBox(height: 16),
                  _buildPlanCard(context, 'Pro', '\$19.99/mo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String title, String price,
      {bool isHighlighted = false}) {
    return GestureDetector(
      onTap: () => _showPaymentDialog(context, title, price),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showPaymentDialog(BuildContext context, String plan, String price) {
  //   final TextEditingController bkashNumberController = TextEditingController();
  //   final TextEditingController transactionIdController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape:
  //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Icon(Icons.payment,
  //                     size: 50, color: Colors.deepPurple),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   'Subscribe to $plan',
  //                   style: const TextStyle(
  //                       fontSize: 22, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 _buildTextField(
  //                   controller: bkashNumberController,
  //                   label: 'Bkash Number',
  //                   icon: Icons.phone_android,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildTextField(
  //                   controller: transactionIdController,
  //                   label: 'Bkash Transaction ID',
  //                   icon: Icons.lock,
  //                 ),
  //                 const SizedBox(height: 25),
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       String bkashNumber = bkashNumberController.text.trim();
  //                       String transactionId = transactionIdController.text.trim();
  //                       if (bkashNumber.isEmpty || transactionId.isEmpty) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                               content: Text('Please fill all fields')),
  //                         );
  //                         return;
  //                       }
  //
  //                       // Save subscription info as pending
  //                       await FirebaseFirestore.instance
  //                           .collection("serviceApp")
  //                           .doc("appData")
  //                           .collection("admins")
  //                           .doc(adminId)
  //                           .collection("subscriptions")
  //                           .add({
  //                         'plan': plan,
  //                         'price': price,
  //                         'bkash_number': bkashNumber,
  //                         'transaction_id': transactionId,
  //                         'status': 'pending', // <-- pending status
  //                         'timestamp': FieldValue.serverTimestamp(),
  //                       });
  //
  //                       Navigator.pop(context);
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text('Subscription request sent! Waiting for approval.')),
  //                       );
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       padding: const EdgeInsets.symmetric(vertical: 15),
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12)),
  //                       backgroundColor: Colors.deepPurple,
  //                     ),
  //                     child: Text(
  //                       'Pay $price',
  //                       style: const TextStyle(
  //                           fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text(
  //                     'Cancel',
  //                     style: TextStyle(color: Colors.grey),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showPaymentDialog(BuildContext context, String plan, String price) {
    final TextEditingController bkashNumberController = TextEditingController();
    final TextEditingController transactionIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.payment, size: 50, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  Text(
                    'Subscribe to $plan',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: bkashNumberController,
                    label: 'Bkash Number',
                    icon: Icons.phone_android,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: transactionIdController,
                    label: 'Bkash Transaction ID',
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Commented out previous condition and Firestore save
                        /*
                      String bkashNumber = bkashNumberController.text.trim();
                      String transactionId = transactionIdController.text.trim();
                      if (bkashNumber.isEmpty || transactionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                        return;
                      }

                      await FirebaseFirestore.instance
                          .collection("serviceApp")
                          .doc("appData")
                          .collection("admins")
                          .doc(adminId)
                          .collection("subscriptions")
                          .add({
                        'plan': plan,
                        'price': price,
                        'bkash_number': bkashNumber,
                        'transaction_id': transactionId,
                        'status': 'pending',
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      */

                        Navigator.pop(context); // close dialog

                        // Navigate directly to NotificationScreen
                      Get.toNamed("/navigation");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Subscription accepted!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text(
                        'Pay $price',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
        required String label,
        required IconData icon,
        bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
