import 'package:flutter/material.dart';

class AboutUsActivity extends StatefulWidget {
  const AboutUsActivity({Key? key}) : super(key: key);

  @override
  State<AboutUsActivity> createState() => _AboutUsActivityState();
}

class _AboutUsActivityState extends State<AboutUsActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.grey.shade600,
            size: 35,
          ),
        ),
        title: Text(
          'About Us',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GHOST',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 45,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'Copyright © 2024 Cairo Egypt, All Rights Reserved.\n'
                'GHOST is a cars app built with Flutter and Firebase technologies.\n'
                'We specialize in participating in hackathons and bringing groundbreaking ideas to life.\n'
                'Our goal is to push the boundaries of what is possible and make a positive impact through our projects.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Mohamed Essam',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
