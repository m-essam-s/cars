import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cars/components/build_textfield.dart';
import 'package:cars/components/build_button.dart';

class ResetPassword extends StatefulWidget {
  final Function()? onTap;
  const ResetPassword({super.key, required this.onTap});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future reset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'A password reset link has been sent to ${emailController.text}'),
            );
          });
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.grey.shade500,
            size: 35,
          ),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.grey.shade500,
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
            const SizedBox(height: 300),

            // logo
            const Icon(
              Icons.android_rounded,
              size: 200,
            ),

            // welcome back, you've been missed!
            const Center(
              child: Text(
                'VARIFICATION!',
                style: TextStyle(
                    color: Color.fromARGB(255, 29, 29, 29),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: Text(
                  'Enter your email and we will send you a link to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            BuildTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // sign in button
            BuildButton(
              text: "Reset Password",
              onTap: reset,
            ),
          ],
        ),
      ),
    );
  }
}
