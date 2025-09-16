// Mock Admin Model
class AdminsModel {
  final String id;
  final String name;
  final String email;
  final String workType;
  final String? imageUrl;

  AdminsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.workType,
    this.imageUrl,
  });
}