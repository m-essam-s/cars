import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// BookmarkIconButton
class BookmarkIconButton extends StatefulWidget {
  final String carId;

  const BookmarkIconButton({
    super.key,
    required this.carId,
  });

  @override
  State<BookmarkIconButton> createState() => _BookmarkIconButtonState();
}

class _BookmarkIconButtonState extends State<BookmarkIconButton> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // Load the Bookmark status from Firestore when the widget is created
    _loadFavoriteStatus();
  }

  // Load the Bookmark status from Firestore
  void _loadFavoriteStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('bookmarks')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.carId)
          .get();

      setState(() {
        _isBookmarked = snapshot.exists;
      });
    }
  }

  // Toggle the 'Bookmark' status and update Firestore
  void _toggleBookmark() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final bookmarkRef = FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.carId);

      if (_isBookmarked) {
        // Remove from Bookmarks
        await bookmarkRef.delete();
      } else {
        // Add to Bookmarks
        await bookmarkRef.set({
          'carId': widget.carId,
        });
      }

      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isBookmarked
          ? const Icon(Icons.bookmark_added)
          : const Icon(Icons.bookmark_add_outlined),
      iconSize: 30,
      onPressed: _toggleBookmark,
    );
  }
}
