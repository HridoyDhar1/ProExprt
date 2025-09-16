

// Mock order model
class MockOrder {
  String id;
  String serviceName;
  String date;
  String time;
  String status;
  String? imageUrl;

  MockOrder({
    required this.id,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    this.imageUrl,
  });
}