import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_details.dart';

class BookingListScreen extends StatefulWidget {
  static const String name = '/bookings';

  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  // Mock booking data
  final List<Map<String, dynamic>> mockBookings = [
    {
      "id": "1",
      "serviceName": "House Cleaning",
      "price": "50",
      "location": "123 Main St",
      "date": "2025-09-10",
      "time": "10:00 AM",
      "status": "completed",
      "providerUserId": "p1",
      "createdAt": "2025-09-01"
    },
    {
      "id": "2",
      "serviceName": "Plumbing",
      "price": "80",
      "location": "456 Service Lane",
      "date": "2025-09-12",
      "time": "2:00 PM",
      "status": "pending",
      "providerUserId": "p2",
      "createdAt": "2025-09-02"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('My Bookings'),
      ),
      body: mockBookings.isEmpty
          ? const Center(
              child: Text(
                'No bookings yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockBookings.length,
              itemBuilder: (context, index) {
                final booking = mockBookings[index];
                return BookingCard(
                  booking: booking,
                  bookingId: booking["id"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          booking: booking,
                          bookingId: booking["id"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final String bookingId;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.bookingId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking["serviceName"] ?? "Unknown Service",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking["status"]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (booking["status"] ?? "pending").toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date & Time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(booking["date"]),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    booking["time"] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking["location"] ?? "No location",
                      style: const TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Price
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    "\$${booking["price"] ?? "0"}",
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "in progress":
        return Colors.orange;
      default: // pending
        return Colors.blue;
    }
  }
}
