import 'package:app/feature/Admin/notification/data/model/notificaton_model.dart';
import 'package:app/feature/Admin/notification/presentation/widget/notification_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class AdminOrdersScreen extends StatefulWidget {
  final VoidCallback? onOrdersViewed;
  const AdminOrdersScreen({super.key, this.onOrdersViewed});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // Mock orders
  final List<MockOrder> _orders = [
    MockOrder(
      id: '1',
      serviceName: 'Cleaning Service',
      date: '2025-09-08',
      time: '10:00 AM',
      status: 'pending',
      imageUrl: null,
    ),
    MockOrder(
      id: '2',
      serviceName: 'Plumbing Service',
      date: '2025-09-09',
      time: '02:00 PM',
      status: 'accepted',
      imageUrl: null,
    ),
    MockOrder(
      id: '3',
      serviceName: 'Electrical Service',
      date: '2025-09-10',
      time: '11:00 AM',
      status: 'declined',
      imageUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Call the callback when orders screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOrdersViewed?.call();
    });
  }

  // Update order status locally
  void updateOrder(String orderId, String status) {
    setState(() {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index].status = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Notifications")),
      ),
      body: _orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                Color statusColor;
                if (order.status == "accepted") {
                  statusColor = Colors.green;
                } else if (order.status == "declined") {
                  statusColor = Colors.red;
                } else {
                  statusColor = Colors.orange;
                }

                return InkWell(
                  onTap: () {
                    Get.to(() => AdminBookingDetailsScreen(
                          orderId: order.id,
                          bookingData: {
                            "serviceName": order.serviceName,
                            "date": order.date,
                            "time": order.time,
                            "status": order.status,
                            "imageUrl": order.imageUrl,
                          },
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // leading avatar
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: (order.imageUrl != null &&
                                  order.imageUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    order.imageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(Icons.notifications,
                                          size: 30);
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Colors.pink,
                                ),
                        ),
                        const SizedBox(width: 12),

                        // text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Date: ${order.date}\nTime: ${order.time}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Status: ${order.status.toUpperCase()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
