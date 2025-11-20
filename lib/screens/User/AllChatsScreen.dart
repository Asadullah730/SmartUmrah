import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_umrah_app/screens/User/chatScreen.dart';

class AllChatsScreen extends StatelessWidget {
  AllChatsScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Umrah Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('participants', arrayContains: currentUserId)
            .orderBy('lastTimestamp', descending: true)
            .snapshots()
            .handleError((error) {
              print("Firestore error: $error");
            }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final data = chatDoc.data() as Map<String, dynamic>;

              final participants = List<String>.from(data['participants']);
              final partnerId = participants.firstWhere(
                (id) => id != currentUserId,
              );

              final lastMessage = data['lastMessage'] ?? "Tap to chat";
              final lastStatus = data.containsKey('lastMessageStatus')
                  ? data['lastMessageStatus']
                  : "sent";
              final lastSenderId = data.containsKey('lastSenderId')
                  ? data['lastSenderId']
                  : "";

              final Timestamp? lastTimestamp = data['lastTimestamp'];
              String formattedTime = "dd/mm/yyyy";

              if (lastTimestamp != null) {
                DateTime dateTime = lastTimestamp.toDate();
                formattedTime = _formatTime(dateTime);
              }

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('TravelAgent')
                    .doc(partnerId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text("Loading..."),
                      subtitle: Text(""),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;
                  final partnerName = userData?['name'] ?? "Unknown";
                  final profileImageUrl = userData?['profileImageUrl'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      backgroundImage:
                          profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: profileImageUrl == null || profileImageUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(partnerName),
                    subtitle: Row(
                      children: [
                        if (lastSenderId == currentUserId)
                          _buildMessageStatusIcon(lastStatus),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      formattedTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () async {
                      final chatId = getChatId(currentUserId, partnerId);
                      final chatRef = _firestore
                          .collection('chats')
                          .doc(chatId);

                      final chatSnapshot = await chatRef.get();
                      if (!chatSnapshot.exists) {
                        await chatRef.set({
                          'participants': [currentUserId, partnerId],
                          'lastMessage': '',
                          'lastTimestamp': FieldValue.serverTimestamp(),
                          'lastMessageStatus': 'sent',
                          'lastSenderId': currentUserId,
                        });
                      }

                      Get.to(
                        () => ChatScreen(
                          partnerId: partnerId,
                          partnerName: partnerName,
                          partnerImageUrl: profileImageUrl,
                        ),
                      );
                    },
                    onLongPress: () {
                      _showDeleteDialog(context, chatDoc.id);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// build ticks like WhatsApp
  Widget _buildMessageStatusIcon(String status) {
    switch (status) {
      case "sent":
        return const Icon(Icons.check, size: 16, color: Colors.grey);
      case "delivered":
        return const Icon(Icons.done_all, size: 16, color: Colors.grey);
      case "seen":
        return const Icon(Icons.done_all, size: 16, color: Colors.blue);
      default:
        return const SizedBox.shrink();
    }
  }

  /// delete chat dialog
  void _showDeleteDialog(BuildContext context, String chatId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Chat"),
        content: const Text("Are you sure you want to delete this chat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.collection('chats').doc(chatId).delete();
              Navigator.pop(ctx);
              Get.snackbar(
                "Chat Deleted",
                "The chat has been deleted successfully",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();

    if (now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      return DateFormat.jm().format(dateTime);
    } else if (now.difference(dateTime).inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd/MM/yyyy").format(dateTime);
    }
  }
}
