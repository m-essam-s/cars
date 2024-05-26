import 'package:cars/components/build_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// RentingConfirmationButton
class RentingConfirmationButton extends StatefulWidget {
  final String carId;
  // final String name;
  // final String oneDayRent;
  // final String imageURL;
  // final String status;

  const RentingConfirmationButton({
    super.key,
    required this.carId,
    // required this.name,
    // required this.oneDayRent,
    // required this.imageURL,
    // required this.status,
  });

  @override
  State<RentingConfirmationButton> createState() =>
      _RentingConfirmationButtonState();
}

class _RentingConfirmationButtonState extends State<RentingConfirmationButton> {
  bool _isRented = false;

  @override
  void initState() {
    super.initState();
    // Load the favorite status from Firestore when the widget is created
    _loadFavoriteStatus();
  }

  // Load the favorite status from Firestore
  void _loadFavoriteStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('rentals')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.carId)
          .get();

      setState(() {
        _isRented = snapshot.exists;
      });
    }
  }

  // Toggle the 'favorite' status and update Firestore
  void _toggleRent() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final favoriteRef = FirebaseFirestore.instance
          .collection('rentals')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.carId);

      if (_isRented) {
        // Remove from favorites
        await favoriteRef.delete();
      } else {
        // Add to favorites
        await favoriteRef.set({
          'carId': widget.carId,
          // 'name': widget.name,
          // 'oneDayRent': widget.oneDayRent,
          // 'imageURL': widget.imageURL,
          // 'status': widget.status
        });
      }

      setState(() {
        _isRented = !_isRented;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildButton(
          onTap: _toggleRent,
          text: _isRented ? 'Cancel Rent' : 'Confrim Rent',
        ),
      ],
    );
  }
}
