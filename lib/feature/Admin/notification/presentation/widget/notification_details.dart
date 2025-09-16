// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class AdminBookingDetailsScreen extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> bookingData;
//   final Map<String, dynamic>? userData; // Optional user data
//
//   const AdminBookingDetailsScreen({
//     super.key,
//     required this.orderId,
//     required this.bookingData,
//     this.userData,
//   });
//
//   @override
//   State<AdminBookingDetailsScreen> createState() => _AdminBookingDetailsScreenState();
// }
//
// class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> {
//   late Map<String, dynamic> userData;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Use passed userData if available, otherwise empty map
//     userData = widget.userData ?? {};
//   }
//
//   void updateOrderStatus(String status) {
//     // Update locally only
//     setState(() {
//       widget.bookingData["status"] = status;
//     });
//
//     Get.snackbar(
//       "Success",
//       "Order status updated to $status",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         title: const Text('Order Details'),
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Status Card
//             _buildCard(
//               child: Column(
//                 children: [
//                   Text(
//                     'ORDER STATUS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(widget.bookingData["status"]),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       (widget.bookingData["status"] ?? "pending").toUpperCase(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.check, color: Colors.white),
//                         label: const Text('Accept', style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                         onPressed: () => updateOrderStatus("accepted"),
//                       ),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.close, color: Colors.white),
//                         label: const Text('Decline', style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         onPressed: () => updateOrderStatus("declined"),
//                       ),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.done_all, color: Colors.white),
//                         label: const Text('Complete', style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                         onPressed: () => updateOrderStatus("completed"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Service Details Card
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Divider(),
//                   _buildDetailRow('Service', widget.bookingData["serviceName"] ?? "Unknown Service"),
//                   _buildDetailRow('Price', "\$${widget.bookingData["price"] ?? "0"}"),
//                   _buildDetailRow('Location', widget.bookingData["location"] ?? "No location"),
//                   _buildDetailRow('Date', _formatDate(widget.bookingData["date"])),
//                   _buildDetailRow('Time', widget.bookingData["time"] ?? "No time specified"),
//                   if (widget.bookingData["imageUrl"] != null)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 8),
//                         const Text('Service Image:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
//                         const SizedBox(height: 8),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             widget.bookingData["imageUrl"],
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 height: 200,
//                                 color: Colors.grey[200],
//                                 child: const Icon(Icons.broken_image, size: 50),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Customer Details Card
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Divider(),
//                   if (userData.isEmpty)
//                     const Text("Customer information not available")
//                   else
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       leading: CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.grey[200],
//                         child: ClipOval(
//                           child: (userData["profileImage"] != null && userData["profileImage"].toString().isNotEmpty)
//                               ? Image.network(
//                                   userData["profileImage"],
//                                   width: 60,
//                                   height: 60,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30),
//                                 )
//                               : const Icon(Icons.person, size: 30),
//                         ),
//                       ),
//                       title: Text(userData["name"] ?? "Customer", style: const TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (userData["email"] != null) Text(userData["email"]),
//                           if (userData["phone"] != null) Text(userData["phone"]),
//                           if (userData["address"] != null) _buildDetailRow('Address', userData["address"]),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Order Information Card
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Order Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Divider(),
//                   _buildDetailRow('Order ID', widget.orderId),
//                   _buildDetailRow('Order Date', _formatDate(widget.bookingData["createdAt"]?.toString())),
//                   if (widget.bookingData["providerEmail"] != null)
//                     _buildDetailRow('Provider Email', widget.bookingData["providerEmail"]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: child,
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(String? dateString) {
//     if (dateString == null) return "No date";
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('MMM dd, yyyy').format(date);
//     } catch (e) {
//       return "Invalid date";
//     }
//   }
//
//   Color _getStatusColor(String? status) {
//     switch (status) {
//       case "accepted":
//         return Colors.green;
//       case "declined":
//         return Colors.red;
//       case "completed":
//         return Colors.blue;
//       case "in progress":
//         return Colors.orange;
//       default: // pending
//         return Colors.grey;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AdminBookingDetailsScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic>? userData;

  const AdminBookingDetailsScreen({
    super.key,
    required this.orderId,
    required this.bookingData,
    this.userData,
  });

  @override
  State<AdminBookingDetailsScreen> createState() => _AdminBookingDetailsScreenState();
}

class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> with TickerProviderStateMixin {
  late Map<String, dynamic> userData;
  bool isLoading = true;

  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _offsetAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    userData = widget.userData ?? {};

    // Initialize staggered animations for 4 cards
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      final offsetAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
      final fadeAnimation = Tween<double>(begin: 0, end: 1)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _offsetAnimations.add(offsetAnimation);
      _fadeAnimations.add(fadeAnimation);

      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) controller.forward();
      });
    }

    // Simulate individual field-level loading
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    super.dispose();
  }

  void updateOrderStatus(String status) {
    setState(() {
      widget.bookingData["status"] = status;
    });

    Get.snackbar(
      "Success",
      "Order status updated to $status",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _animatedCard(0, isLoading ? _shimmerStatusCard() : _buildStatusCard()),
            const SizedBox(height: 16),
            _animatedCard(1, isLoading ? _shimmerServiceCard() : _buildServiceDetailsCard()),
            const SizedBox(height: 16),
            _animatedCard(2, isLoading ? _shimmerCustomerCard() : _buildCustomerDetailsCard()),
            const SizedBox(height: 16),
            _animatedCard(3, isLoading ? _shimmerOrderInfoCard() : _buildOrderInfoCard()),
          ],
        ),
      ),
    );
  }

  Widget _animatedCard(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _offsetAnimations[index],
        child: child,
      ),
    );
  }

  Widget _shimmerContainer({double height = 16, double width = double.infinity, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ----- Shimmer Cards -----
  Widget _shimmerStatusCard() {
    return _buildCard(
      child: Column(
        children: [
          _shimmerContainer(width: 120, height: 16),
          const SizedBox(height: 8),
          _shimmerContainer(height: 40, radius: BorderRadius.circular(20)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (_) => _shimmerContainer(width: 80, height: 36, radius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _shimmerServiceCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(5, (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _shimmerContainer(height: 16, width: double.infinity),
        )),
      ),
    );
  }

  Widget _shimmerCustomerCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerContainer(width: 150, height: 16),
          const SizedBox(height: 8),
          Row(
            children: [
              _shimmerContainer(width: 60, height: 60, radius: BorderRadius.circular(30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _shimmerContainer(height: 14, width: double.infinity),
                  )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _shimmerOrderInfoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _shimmerContainer(height: 16, width: double.infinity),
        )),
      ),
    );
  }

  // ----- Real Cards -----
  Widget _buildStatusCard() {
    return _buildCard(
      child: Column(
        children: [
          Text(
            'ORDER STATUS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.bookingData["status"]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (widget.bookingData["status"] ?? "pending").toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Accept', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => updateOrderStatus("accepted"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text('Decline', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => updateOrderStatus("declined"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.done_all, color: Colors.white),
                label: const Text('Complete', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => updateOrderStatus("completed"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildDetailRow('Service', widget.bookingData["serviceName"] ?? "Unknown Service"),
          _buildDetailRow('Price', "\$${widget.bookingData["price"] ?? "0"}"),
          _buildDetailRow('Location', widget.bookingData["location"] ?? "No location"),
          _buildDetailRow('Date', _formatDate(widget.bookingData["date"])),
          _buildDetailRow('Time', widget.bookingData["time"] ?? "No time specified"),
          if (widget.bookingData["imageUrl"] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Service Image:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.bookingData["imageUrl"],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          if (userData.isEmpty)
            const Text("Customer information not available")
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: (userData["profileImage"] != null && userData["profileImage"].toString().isNotEmpty)
                      ? Image.network(
                    userData["profileImage"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30),
                  )
                      : const Icon(Icons.person, size: 30),
                ),
              ),
              title: Text(userData["name"] ?? "Customer", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userData["email"] != null) Text(userData["email"]),
                  if (userData["phone"] != null) Text(userData["phone"]),
                  if (userData["address"] != null) _buildDetailRow('Address', userData["address"]),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildDetailRow('Order ID', widget.orderId),
          _buildDetailRow('Order Date', _formatDate(widget.bookingData["createdAt"]?.toString())),
          if (widget.bookingData["providerEmail"] != null)
            _buildDetailRow('Provider Email', widget.bookingData["providerEmail"]),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "No date";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return "Invalid date";
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "declined":
        return Colors.red;
      case "completed":
        return Colors.blue;
      case "in progress":
        return Colors.orange;
      default:
        return Colors.grey; // pending
    }
  }
}
