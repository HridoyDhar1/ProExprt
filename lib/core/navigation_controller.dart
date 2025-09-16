import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var notificationCount = 0.obs; // For admin orders
  var chatCount = 0.obs; // For user messages

  @override
  void onInit() {
    super.onInit();
    // You can initialize mock or local listeners here
    _mockNewOrders();
    _mockNewMessages();
  }

  void updateIndex(int index) {
    selectedIndex.value = index;

    if (index == 1) {
      resetNotificationCount();
    }

    if (index == 2) {
      resetChatCount();
    }
  }

  // Mock new orders
  void _mockNewOrders() {
    // Simulate order notifications
    Future.delayed(Duration(seconds: 5), () {
      notificationCount.value += 1; // Increment notification count
    });
  }

  // Mock new messages
  void _mockNewMessages() {
    // Simulate incoming chat messages
    Future.delayed(Duration(seconds: 3), () {
      chatCount.value += 1; // Increment chat count
    });
  }

  void resetNotificationCount() {
    notificationCount.value = 0;
  }

  void resetChatCount() {
    chatCount.value = 0;
  }

  // Mock mark orders as seen
  Future<void> markOrdersAsSeen() async {
    resetNotificationCount();
  }

  // Mock mark messages as read
  Future<void> markAllMessagesAsRead() async {
    resetChatCount();
  }
}
