import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final Map<String, dynamic>? service;

  const UserChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    this.service,
  });

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ✅ Local chat messages list
  List<Map<String, dynamic>> messages = [
    {
      "senderId": "u1",
      "message": "Hello! How can I help you?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "read": true,
    },
    {
      "senderId": "u2",
      "message": "I need information about your services.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      "read": true,
    },
  ];

  final String currentUserId = "u1"; // ✅ Local user ID

  @override
  void initState() {
    super.initState();
    // Scroll to bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        "senderId": currentUserId,
        "message": text,
        "timestamp": DateTime.now(),
        "read": true,
      });
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _getOtherUserRole() {
    return "Customer"; // or "Service Provider" if needed
  }

  Widget _buildServiceInfo() {
    if (widget.service == null) return const SizedBox.shrink();

    final service = widget.service!;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          service["imageUrl"] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service["imageUrl"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service["post"] ?? "Untitled Service",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${service["price"] ?? '0'}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                if (service["location"] != null)
                  Text(
                    service["location"],
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUserName),
                Text(_getOtherUserRole(), style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          if (widget.service != null) _buildServiceInfo(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final data = messages[index];
                final isMe = data["senderId"] == currentUserId;
                return ChatMessageBubble(
                  message: data["message"],
                  isMe: isMe,
                  timestamp: data["timestamp"],
                  isRead: data["read"] ?? false,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime? timestamp;
  final bool isRead;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.timestamp,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.teal : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 4),
                  if (timestamp != null)
                    Text(
                      DateFormat('HH:mm').format(timestamp!),
                      style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600]),
                    ),
                  if (isMe && isRead) const Icon(Icons.done_all, size: 12, color: Colors.white70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
