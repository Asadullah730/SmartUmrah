// lib/screens/user/umrah_journal_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UmrahJournalScreen extends StatefulWidget {
  const UmrahJournalScreen({super.key});

  @override
  State<UmrahJournalScreen> createState() => _UmrahJournalScreenState();
}

class _UmrahJournalScreenState extends State<UmrahJournalScreen> {
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);

  String? _userId;
  CollectionReference<Map<String, dynamic>>? _journalCollection;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Not logged in — show message and go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to access the journal.')),
        );
        Navigator.of(context).pop();
      });
      return;
    }
    _userId = user.uid;
    _journalCollection = FirebaseFirestore.instance
        .collection('user_journals')
        .doc(_userId)
        .collection('entries');
  }

  // Image picker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  // Upload image to Firebase Storage, return URL or null
  Future<String?> _uploadImage() async {
    if (_imageFile == null || _userId == null) return null;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final destination = 'journal_photos/$_userId/$fileName';
    final ref = FirebaseStorage.instance.ref().child(destination);
    try {
      final task = await ref.putFile(_imageFile!);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      debugPrint('Upload error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Upload unexpected error: $e');
      return null;
    }
  }

  Future<void> _showJournalDialog([
    DocumentSnapshot<Map<String, dynamic>>? doc,
  ]) async {
    String? imageUrl;
    if (doc != null) {
      _titleController.text = doc.data()?['title'] ?? '';
      _contentController.text = doc.data()?['content'] ?? '';
      imageUrl = doc.data()?['photoUrl'] as String?;
      _imageFile = null;
    } else {
      _titleController.clear();
      _contentController.clear();
      _imageFile = null;
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              doc == null ? 'New Journal Entry' : 'Edit Entry',
              style: const TextStyle(color: textColorPrimary),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: textColorPrimary),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: textColorSecondary),
                      filled: true,
                      fillColor: primaryBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(color: textColorPrimary),
                    decoration: InputDecoration(
                      labelText: 'Content',
                      labelStyle: const TextStyle(color: textColorSecondary),
                      filled: true,
                      fillColor: primaryBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  if (_imageFile != null)
                    Image.file(
                      _imageFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  if (_imageFile == null && imageUrl != null)
                    Image.network(
                      imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      setState(() {});
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Add Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: textColorSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                child: Text(
                  doc == null ? 'Add' : 'Update',
                  style: const TextStyle(color: textColorPrimary),
                ),
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final content = _contentController.text.trim();
                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Title and content are required.'),
                      ),
                    );
                    return;
                  }
                  // Show a small loading indicator by disabling the dialog button briefly
                  final snack = ScaffoldMessenger.of(context);
                  try {
                    snack.showSnackBar(
                      const SnackBar(content: Text('Saving entry...')),
                    );
                    final uploadedUrl = await _uploadImage();
                    if (doc == null) {
                      await _journalCollection?.add({
                        'title': title,
                        'content': content,
                        'date': FieldValue.serverTimestamp(),
                        'photoUrl': uploadedUrl,
                      });
                    } else {
                      await _journalCollection?.doc(doc.id).update({
                        'title': title,
                        'content': content,
                        'photoUrl': uploadedUrl ?? imageUrl,
                      });
                    }
                    snack.hideCurrentSnackBar();
                    snack.showSnackBar(
                      const SnackBar(content: Text('Saved successfully.')),
                    );
                    Navigator.of(context).pop();
                  } catch (e, st) {
                    debugPrint('Error saving journal: $e\n$st');
                    snack.hideCurrentSnackBar();
                    snack.showSnackBar(
                      SnackBar(content: Text('Failed to save: $e')),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteEntry(String documentId) async {
    try {
      await _journalCollection?.doc(documentId).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Journal entry deleted.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_journalCollection == null) {
      // user not logged in, or init failed — show safe UI
      return Scaffold(
        appBar: AppBar(
          title: const Text('Umrah Journal'),
          backgroundColor: primaryBackgroundColor,
        ),
        body: const Center(
          child: Text('Unable to load journal (not logged in).'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          'Umrah Journal',
          style: TextStyle(color: textColorPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColorPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: textColorPrimary),
            onPressed: () => _showJournalDialog(),
            tooltip: 'Add new entry',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _journalCollection!
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: accentColor),
            );
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Your journal is empty.',
                style: TextStyle(color: textColorSecondary, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data();
              final timestamp = data['date'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? timestamp.toDate().toLocal().toString().split(' ')[0]
                  : 'No date';
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Card(
                  color: cardBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      data['title'] ?? '',
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          data['content'] ?? '',
                          style: const TextStyle(color: textColorSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (data['photoUrl'] != null)
                          Image.network(
                            data['photoUrl'],
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 6),
                        Text(
                          'Date: $formattedDate',
                          style: const TextStyle(
                            color: textColorSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _showJournalDialog(doc),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: textColorSecondary),
                      onPressed: () => _deleteEntry(doc.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
