import 'package:app/core/navigation_controller.dart';
import 'package:app/feature/User/chat/presentation/screen/chat_list.dart';
import 'package:app/feature/User/home/presentation/screen/home_screen.dart';
import 'package:app/feature/User/profile/presentation/screen/profile_screen.dart';
import 'package:app/feature/User/search/presentation/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomUserNavigationScreen extends StatelessWidget {
  final NavigationController navigationController = Get.find<NavigationController>();
  static const String name = '/user_navigation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Obx(() {
        return IndexedStack(
          index: navigationController.selectedIndex.value,
          children: [
            const UserHomeScreen(),
            const SearchScreen(),
            ChatListScreen(onChatsViewed: () {
              navigationController.markAllMessagesAsRead();
            }),
             UserProfileScreen(),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) {
            navigationController.updateIndex(index);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),

            // Chat with badge
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = navigationController.chatCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.message),
                    if (count > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            count > 9 ? '9+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              label: 'Chat',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
