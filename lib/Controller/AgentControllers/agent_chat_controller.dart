import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  late String chatId;
  bool isGroupChat = false;

  void initChat(String partnerId) async {
    // Detect if partnerId is an existing chat document id (group chat)
    final docSnap = await _firestore.collection('chats').doc(partnerId).get();
    if (docSnap.exists) {
      isGroupChat = true;
      chatId = partnerId; // Use the existing chat doc id
    } else {
      isGroupChat = false;
      chatId = _getChatId(currentUserId, partnerId);
      await _createChatIfNotExists(partnerId);
    }

    // Stream messages
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          messages.value = snapshot.docs;
        });

    // For 1:1 chats, mark sent messages as seen for this user
    if (!isGroupChat) {
      _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'sent')
          .get()
          .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.update({'status': 'seen'});
            }
          });
    }
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  Future<void> _createChatIfNotExists(String partnerId) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [currentUserId, partnerId],
        'lastMessage': '',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> sendMessage(String partnerId, String messageText) async {
    if (messageText.trim().isEmpty) return;

    final messageData = {
      'senderId': currentUserId,
      'receiverId': isGroupChat ? '' : partnerId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent',
      'deletedFor': [],
    };

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messageRef.add(messageData);

    if (isGroupChat) {
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': messageText,
        'lastTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [currentUserId, partnerId],
        'lastMessage': messageText,
        'lastTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> deleteForMe(String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
          'deletedFor': FieldValue.arrayUnion([currentUserId]),
        });
  }

  Future<void> deleteForEveryone(String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat("dd/MM/yyyy").format(date);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat("hh:mm a").format(dateTime);
  }
}
