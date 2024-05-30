import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cars/components/build_textfield.dart';
import 'package:cars/components/build_button.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUserDocument(User user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "email": _emailController.text,
      // Default photoUrl
      "photoUrl":
          "https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Users%2FGhost.png?alt=media&token=3d91e850-feff-40ae-a3aa-0bee873a6446",
      // "role": "user",
      // "createdAt": DateTime.now().millisecondsSinceEpoch,
      // "updatedAt": DateTime.now().millisecondsSinceEpoch,
      // "isVerified": false,
      // "isBlocked": false,
      // "isDeleted": false,
      // "phoneNumber": "",
      // "address": "",
      // "city": "",
      // "state": "",
      // "country": "",
      // "zipCode": "",
      // "bio": "",
      // "rating": 0,
      // "totalRatings": 0,
      // "products": [],
      // "orders": [],
      // "cart": [],
      // "wishlist": [],
      // "notifications": [],
      // "reviews": [],
      // "chats": [],
      // "blockedUsers": [],
      // "reportedUsers": [],
      // "reportedProducts": [],
      // "reportedReviews": [],
      // "reportedMessages": [],
      // "reportedOrders": [],
      // "reportedChats": [],
    });
  }

  bool passwordConfirmed() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  // Sign User Up method
  void signUserUp() async {
    // Try Creating the user
    try {
      // Check if password is confirmed
      if (passwordConfirmed()) {
        // Create user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Add user to Firestore
        await createUserDocument(userCredential.user!);

        // Ensure the dialog is dismissed
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        // Show error message, passwords don't match
        if (mounted) {
          Navigator.pop(context);
        }
        showErrorDialog('Passwords don\'t match!');
      }
    } on FirebaseAuthException catch (e) {
      // Ensure the dialog is dismissed
      if (mounted) {
        Navigator.pop(context);
      }
      showErrorDialog(e.message ?? 'An error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Error message to user
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 100),

            // Let's create an account for you
            const Center(
              child: Text(
                'HELLO THERE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Center(
              child: Text(
                'Let\'s create an account for you!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // First name text field
            BuildTextField(
              controller: _firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // Last name text field
            BuildTextField(
              controller: _lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // Email text field
            BuildTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // Password text field
            BuildTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // Confirm password text field
            BuildTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),

            const SizedBox(height: 20),

            // Sign up button
            BuildButton(
              text: "Sign Up",
              onTap: signUserUp,
            ),

            const SizedBox(height: 20),

            // Already have an account? Login now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
