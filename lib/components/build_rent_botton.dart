import 'package:cars/components/build_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RentingConfirmationButton extends StatefulWidget {
  final String carId;

  const RentingConfirmationButton({
    super.key,
    required this.carId,
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
    _loadRentStatus();
  }

  // Load the favorite status from Firestore
  void _loadRentStatus() async {
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
