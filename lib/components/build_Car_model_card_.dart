import 'package:flutter/material.dart';

class BuildCarModelCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const BuildCarModelCard({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 60,
        child: Card(
          shadowColor: Colors.grey[100],
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: onTap, // Use the provided onTap callback
            child: Row(
              children: [
                const SizedBox(width: 5),
                Text(
                  text, // Use the provided text
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    wordSpacing: 5,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
