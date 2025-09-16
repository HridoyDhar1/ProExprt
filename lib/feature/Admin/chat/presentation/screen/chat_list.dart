// import 'package:app/feature/Admin/chat/presentation/widget/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
//
//
// class AdminChatListScreen extends StatefulWidget {
//   static const String name = '/admin_chats';
//
//   const AdminChatListScreen({super.key});
//
//   @override
//   State<AdminChatListScreen> createState() => _AdminChatListScreenState();
// }
//
// class _AdminChatListScreenState extends State<AdminChatListScreen> {
//   bool _isLoading = false;
//   bool _hasError = false;
//   String _errorMessage = '';
//
//   // ✅ Mock chat list
//   final List<Map<String, dynamic>> _chats = [
//     {
//       "chatId": "1",
//       "participantId": "u1",
//       "participantName": "John Doe",
//       "participantImage": "",
//       "lastMessage": "Hello, how are you?",
//       "lastMessageTime": DateTime.now(),
//       "isProvider": true,
//     },
//     {
//       "chatId": "2",
//       "participantId": "u2",
//       "participantName": "Jane Smith",
//       "participantImage": "",
//       "lastMessage": "Need help with service.",
//       "lastMessageTime": DateTime.now().subtract(const Duration(hours: 3)),
//       "isProvider": false,
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         title: const Center(child: Text('Chats')),
//         backgroundColor: Colors.transparent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _isLoading = true;
//               });
//               Future.delayed(const Duration(milliseconds: 500), () {
//                 setState(() => _isLoading = false);
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _hasError
//               ? _buildErrorWidget()
//               : _buildChatList(),
//     );
//   }
//
//   Widget _buildChatList() {
//     if (_chats.isEmpty) {
//       return const Center(
//         child: Text(
//           'No messages yet',
//           style: TextStyle(fontSize: 18),
//         ),
//       );
//     }
//
//     // Sort chats by lastMessageTime descending
//     _chats.sort((a, b) {
//       final timeA = a["lastMessageTime"] as DateTime;
//       final timeB = b["lastMessageTime"] as DateTime;
//       return timeB.compareTo(timeA);
//     });
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _chats.length,
//       itemBuilder: (context, index) {
//         final chat = _chats[index];
//         return AdminChatListItem(
//           chatId: chat["chatId"],
//           participantId: chat["participantId"],
//           participantName: chat["participantName"],
//           participantImage: chat["participantImage"],
//           lastMessage: chat["lastMessage"],
//           lastMessageTime: chat["lastMessageTime"],
//           isProvider: chat["isProvider"],
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => UserChatScreen(
//                   chatId: chat["chatId"],
//                   otherUserId: chat["participantId"],
//                   otherUserName: chat["participantName"],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.orange),
//             const SizedBox(height: 20),
//             const Text(
//               'Setup Required',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _hasError = false;
//                   _isLoading = true;
//                 });
//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   setState(() => _isLoading = false);
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey[300],
//               ),
//               child: const Text('Try Again', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AdminChatListItem extends StatelessWidget {
//   final String chatId;
//   final String participantId;
//   final String participantName;
//   final String? participantImage;
//   final String lastMessage;
//   final DateTime? lastMessageTime;
//   final bool isProvider;
//   final VoidCallback onTap;
//
//   const AdminChatListItem({
//     super.key,
//     required this.chatId,
//     required this.participantId,
//     required this.participantName,
//     this.participantImage,
//     required this.lastMessage,
//     this.lastMessageTime,
//     required this.isProvider,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: participantImage != null && participantImage!.isNotEmpty
//                       ? NetworkImage(participantImage!)
//                       : null,
//                   child: participantImage == null || participantImage!.isEmpty
//                       ? const Icon(Icons.person, size: 25)
//                       : null,
//                 ),
//                 if (isProvider)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: const BoxDecoration(
//                         color: Colors.teal,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.verified_user, size: 12, color: Colors.white),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         participantName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       if (isProvider)
//                         const Icon(Icons.work, size: 14, color: Colors.teal),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     lastMessage.isNotEmpty ? lastMessage : "Start a conversation...",
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 14,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             if (lastMessageTime != null)
//               Text(
//                 _formatTime(lastMessageTime!),
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//
//     if (time.isAfter(today)) {
//       return DateFormat('HH:mm').format(time);
//     } else if (time.isAfter(yesterday)) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('MMM dd').format(time);
//     }
//   }
// }
import 'package:app/feature/Admin/chat/presentation/widget/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AdminChatListScreen extends StatefulWidget {
  static const String name = '/admin_chats';

  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, dynamic>> _chats = []; // Chats fetched from database
  final List<bool> _isLoadingList = []; // Track shimmer per item

  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    // Simulate network fetch delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with your actual database fetching
    final fetchedChats = [
      {
        "chatId": "1",
        "participantId": "u1",
        "participantName": "John Doe",
        "participantImage": "",
        "lastMessage": "Hello, how are you?",
        "lastMessageTime": DateTime.now(),
        "isProvider": true,
      },
      {
        "chatId": "2",
        "participantId": "u2",
        "participantName": "Jane Smith",
        "participantImage": "",
        "lastMessage": "Need help with service.",
        "lastMessageTime": DateTime.now().subtract(const Duration(hours: 3)),
        "isProvider": false,
      },
    ];

    // Initialize shimmer list
    _isLoadingList.clear();
    _isLoadingList.addAll(List.generate(fetchedChats.length, (index) => true));

    setState(() {
      _chats = fetchedChats;
      _isFetching = false;
    });

    // Animate shimmer removal per item
    for (int i = 0; i < _chats.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        if (mounted) {
          setState(() {
            _isLoadingList[i] = false;
          });
        }
      });
    }
  }

  // Call this when a new chat is added from backend (like a new message notification)
  void _insertNewChat(Map<String, dynamic> newChat) {
    _chats.insert(0, newChat);
    _isLoadingList.insert(0, true);
    _listKey.currentState?.insertItem(0,
        duration: const Duration(milliseconds: 500));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isLoadingList[0] = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Center(child: Text('Chats')),
        backgroundColor: Colors.transparent,
      ),
      body: _isFetching && _chats.isEmpty
          ? _buildInitialSkeleton()
          : AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16),
        initialItemCount: _chats.length,
        itemBuilder: (context, index, animation) {
          final chat = _chats[index];
          return SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            child: FadeTransition(
              opacity: animation,
              child: _isLoadingList[index]
                  ? _buildShimmerItem()
                  : AdminChatListItem(
                chatId: chat["chatId"],
                participantId: chat["participantId"],
                participantName: chat["participantName"],
                participantImage: chat["participantImage"],
                lastMessage: chat["lastMessage"],
                lastMessageTime: chat["lastMessageTime"],
                isProvider: chat["isProvider"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserChatScreen(
                        chatId: chat["chatId"],
                        otherUserId: chat["participantId"],
                        otherUserName: chat["participantName"],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, color: Colors.white, width: 120),
                  const SizedBox(height: 6),
                  Container(height: 12, color: Colors.white, width: 180),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(height: 12, width: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class AdminChatListItem extends StatelessWidget {
  final String chatId;
  final String participantId;
  final String participantName;
  final String? participantImage;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isProvider;
  final VoidCallback onTap;

  const AdminChatListItem({
    super.key,
    required this.chatId,
    required this.participantId,
    required this.participantName,
    this.participantImage,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: participantImage != null &&
                      participantImage!.isNotEmpty
                      ? NetworkImage(participantImage!)
                      : null,
                  child: participantImage == null || participantImage!.isEmpty
                      ? const Icon(Icons.person, size: 25)
                      : null,
                ),
                if (isProvider)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user,
                          size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        participantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isProvider)
                        const Icon(Icons.work, size: 14, color: Colors.teal),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.isNotEmpty
                        ? lastMessage
                        : "Start a conversation...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (lastMessageTime != null)
              Text(
                _formatTime(lastMessageTime!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (time.isAfter(today)) {
      return DateFormat('HH:mm').format(time);
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(time);
    }
  }
}
