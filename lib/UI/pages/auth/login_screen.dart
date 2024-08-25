import 'package:cars/UI/component/auth/auth_button.dart';
import 'package:cars/UI/component/auth/auth_textfield.dart';
import 'package:cars/server/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    Future<void> _signIn() async {
      // check if already registered
      if (await AuthService().isRegistered(_emailController.toString())) {
        // showing password field
        // ignore: avoid_print
      } else {
        // show error message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Here you go!'),
              content: Column(
                children: [
                  const Text('User not registered yet!'),
                  const Text('Create an account to continue!'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('let\'s go!'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Re-enter email'),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Hello, There!'),
            const Text('Welcome to the Cars App!'),
            AuthTextfield(
              hintText: 'Email: example@email.com',
              controller: _emailController,
              obscureText: false,
            ),
            AuthButton(onTap: null, text: 'Sign In'),
          ],
        ),
      ),
    );
  }
}
