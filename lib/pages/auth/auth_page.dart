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
          //user is logged in
          if (snapshot.hasData) {
            return Core();
          }

          //user is NOT logged in
          else {
            return const SignInOrUp();
          }
        },
      ),
    );
  }
}
