import 'package:flutter/material.dart';
import 'package:cars/Pages/auth/sign_in_page.dart';
import 'package:cars/Pages/auth/sign_up_page.dart';

class SignInOrUp extends StatefulWidget {
  const SignInOrUp({super.key});

  @override
  State<SignInOrUp> createState() => _SignInOrUpState();
}

class _SignInOrUpState extends State<SignInOrUp> {
  // initially show login page
  bool showLoginPage = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(
        onTap: togglePages,
      );
    } else {
      return SignUpPage(
        onTap: togglePages,
      );
    }
  }
}
