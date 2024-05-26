import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cars/components/build_textfield.dart';
import 'package:cars/components/build_button.dart';

class EditProfileActivity extends StatefulWidget {
  final Function()? onTap;
  const EditProfileActivity({super.key, required this.onTap});

  @override
  State<EditProfileActivity> createState() => _EditProfileActivityState();
}

class _EditProfileActivityState extends State<EditProfileActivity> {
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(
            '${firstnameController.text} ${lastnameController.text}');
        // Additional logic to update other user information if needed
        // For example, you can update the email address with user.updateEmail(newEmail)

        // Show success dialog
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Profile updated successfully!'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Show error dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.grey,
            size: 35,
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 30,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto',
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 180),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 70,
                    backgroundImage: const NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Ghost.png?alt=media&token=b6243bac-1e26-433e-a9ed-23a0a654358f"),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 100,
                    child: IconButton(
                      color: Colors.grey[800],
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo_outlined),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: Text(
                  'Update your profile information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            BuildTextField(
              controller: firstnameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            BuildTextField(
              controller: lastnameController,
              hintText: 'Last Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            BuildButton(
              text: "Update",
              onTap: updateProfile,
            ),
          ],
        ),
      ),
    );
  }
}
