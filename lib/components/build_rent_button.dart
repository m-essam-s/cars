import 'package:cars/pages/widgets/renting_page_activity.dart';
import 'package:flutter/material.dart';

class BuildRentButton extends StatelessWidget {
  final String text;

  final String name;
  final String img;
  final String oneDayRent;
  final String status;
  final String CarID;

  const BuildRentButton({
    super.key,
    required this.text,
    required this.name,
    required this.img,
    required this.oneDayRent,
    required this.status,
    required this.CarID,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 50,
        width: 120,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RentingPage(
                    name: name,
                    img: img,
                    oneDayRent: oneDayRent,
                    status: status,
                    carID: CarID,
                  );
                },
              ),
            );
          }, // Use the provided onTap callback
          child: Text(
            text.toUpperCase(), // Use the provided text
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              letterSpacing: 2,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
