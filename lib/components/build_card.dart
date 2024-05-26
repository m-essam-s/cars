import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const BuildCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 60,
        child: Card(
          shadowColor: Colors.grey[200],
          color: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: onTap, // Use the provided onTap callback
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  icon, // Use the provided icon
                  size: 25,
                  weight: 10,
                ),
                const SizedBox(width: 5),
                Text(
                  text, // Use the provided text
                  style: const TextStyle(
                    color: Color.fromARGB(255, 29, 29, 29),
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
