import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;
  final String bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic>? providerData;

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  // Mock provider data
  void _loadProviderData() {
    final providerId = widget.booking["providerUserId"];

    // Example mock data; you can replace this with local storage or API
    providerData = providerId != null
        ? {
            "name": "Jane Smith",
            "email": "janesmith@example.com",
            "number": "0987654321",
            "location": "456 Service Lane",
            "workType": "Plumbing",
            "companyName": "Jane's Services",
            "profileImage": null, // Or provide a local asset path
          }
        : null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details
            _containerCard(
              title: "Service Details",
              children: [
                _buildDetailRow(
                  'Service',
                  widget.booking["serviceName"] ?? "Unknown Service",
                ),
                _buildDetailRow(
                  'Price',
                  "\$${widget.booking["price"] ?? "0"}",
                ),
                _buildDetailRow(
                  'Location',
                  widget.booking["location"] ?? "No location",
                ),
                _buildDetailRow(
                  'Date',
                  _formatDate(widget.booking["date"]),
                ),
                _buildDetailRow(
                  'Time',
                  widget.booking["time"] ?? "No time specified",
                ),
                _buildDetailRow(
                  'Status',
                  widget.booking["status"] ?? "pending",
                  status: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Provider Details
            _containerCard(
              title: "Service Provider",
              children: [
                if (providerData != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: (providerData!["profileImage"] != null &&
                                providerData!["profileImage"]
                                    .toString()
                                    .isNotEmpty)
                            ? Image.asset(
                                providerData!["profileImage"],
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
                    title: Text(
                      providerData!["name"] ?? "Service Provider",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (providerData!["email"] != null)
                          Text(providerData!["email"]),
                        if (providerData!["number"] != null)
                          Text(providerData!["number"]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (providerData!["location"] != null)
                    _buildDetailRow(
                      'Provider Location',
                      providerData!["location"],
                    ),
                  if (providerData!["workType"] != null)
                    _buildDetailRow(
                      'Work Type',
                      providerData!["workType"],
                    ),
                  if (providerData!["companyName"] != null)
                    _buildDetailRow(
                      'Company',
                      providerData!["companyName"],
                    ),
                ] else
                  const Text(
                    "Provider information not available",
                    style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Info
            _containerCard(
              title: "Booking Information",
              children: [
                _buildDetailRow('Booking ID', widget.bookingId),
                _buildDetailRow(
                  'Order Date',
                  _formatDate(widget.booking["createdAt"]?.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerCard({required String title, required List<Widget> children}) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool status = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: status
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(value),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(value),
          ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "in progress":
        return Colors.orange;
      default:
        return Colors.blue; // pending
    }
  }
}
