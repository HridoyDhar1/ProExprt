import 'package:app/core/navigation_controller.dart';
import 'package:app/feature/Admin/chat/presentation/widget/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import 'dart:async';
import 'package:app/core/navigation_controller.dart';
import 'package:app/feature/Admin/chat/presentation/widget/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/chat_list_iteam.dart';

class ChatListScreen extends StatefulWidget {
  final VoidCallback? onChatsViewed;

  const ChatListScreen({super.key, this.onChatsViewed});

  static const String name = '/chats';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final NavigationController navigationController = Get.find<NavigationController>();
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, int> _unreadCounts = {};

  final String userId = "user123";
  List<Map<String, dynamic>> chats = [];

  // debounce
  Timer? _debounceTimer;

  // coalesce save queue
  final Set<String> _pendingReadUpdates = {};
  Timer? _coalesceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChatsViewed?.call();
    });
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate fetch

      chats = [
        {
          "chatId": "chat1",
          "participants": {
            "user123": {"name": "You", "isProvider": false},
            "user456": {"name": "John Doe", "imageUrl": "", "isProvider": true}
          },
          "lastMessage": "Hello, are you available?",
          "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 10)),
        },
        {
          "chatId": "chat2",
          "participants": {
            "user123": {"name": "You", "isProvider": false},
            "user789": {"name": "Jane Smith", "imageUrl": "", "isProvider": false}
          },
          "lastMessage": "Thanks for your help!",
          "lastMessageTime": DateTime.now().subtract(const Duration(days: 1)),
        },
      ];

      for (var chat in chats) {
        _unreadCounts[chat["chatId"]] = 2;
      }

      _updateTotalUnreadCount();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading chats: $e';
      });
    }
  }

  void _updateTotalUnreadCount() {
    int total = _unreadCounts.values.fold(0, (a, b) => a + b);
    navigationController.chatCount.value = total;
  }

  void _markChatAsRead(String chatId) {
    setState(() {
      _unreadCounts[chatId] = 0;
    });
    _updateTotalUnreadCount();

    // add to pending queue for coalesce save
    _pendingReadUpdates.add(chatId);

    // schedule batch save
    _coalesceTimer?.cancel();
    _coalesceTimer = Timer(const Duration(seconds: 2), _flushPendingUpdates);
  }

  void _flushPendingUpdates() {
    if (_pendingReadUpdates.isEmpty) return;

    print("Saving batched read updates: $_pendingReadUpdates");
    _pendingReadUpdates.clear();
  }

  void _onChatTap(String chatId, Widget page) {
    // debounce tap
    if (_debounceTimer?.isActive ?? false) return;

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {});

    _markChatAsRead(chatId);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Messages')),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? _buildShimmerList()
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : chats.isEmpty
          ? const Center(child: Text('No messages yet', style: TextStyle(fontSize: 18)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          final participants = Map<String, dynamic>.from(chat["participants"]);
          participants.remove(userId);

          if (participants.isEmpty) return const SizedBox();

          final otherParticipantId = participants.keys.first;
          final otherParticipant = participants.values.first;
          final unreadCount = _unreadCounts[chat["chatId"]] ?? 0;

          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: ChatListItem(
              chatId: chat["chatId"],
              participantId: otherParticipantId,
              participantName: otherParticipant["name"] ?? "Unknown",
              participantImage: otherParticipant["imageUrl"],
              lastMessage: chat["lastMessage"] ?? "",
              lastMessageTime: chat["lastMessageTime"],
              isProvider: otherParticipant["isProvider"] ?? false,
              unreadCount: unreadCount,
              onTap: () => _onChatTap(
                chat["chatId"],
                UserChatScreen(
                  chatId: chat["chatId"],
                  otherUserId: otherParticipantId,
                  otherUserName: otherParticipant["name"] ?? "Unknown",
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}


// ChatListItem widget
