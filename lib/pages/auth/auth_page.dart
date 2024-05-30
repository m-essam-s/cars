import 'package:flutter/material.dart';
import 'package:cars/Pages/auth/sign_in_or_up.dart';
import 'package:cars/Pages/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle errors in the stream
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          // User is logged in
          if (snapshot.hasData) {
            return const Core();
          }

          // User is NOT logged in
          return const SignInOrUp();
        },
      ),
    );
  }
}
