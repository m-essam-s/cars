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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: showLoginPage
          ? SignInPage(
              key: const ValueKey('SignInPage'),
              onTap: togglePages,
            )
          : SignUpPage(
              key: const ValueKey('SignUpPage'),
              onTap: togglePages,
            ),
    );
  }
}
