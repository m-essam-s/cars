// import 'package:car_rental_app/components/build_button.dart';
import 'package:cars/components/build_renting_confirmation_botton.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class RentingPage extends StatefulWidget {
  final String name;
  final String img;
  final String oneDayRent;
  final String status;
  final String carID;

  const RentingPage({
    Key? key,
    required this.name,
    required this.img,
    required this.oneDayRent,
    required this.status,
    required this.carID,
  }) : super(key: key);

  @override
  _RentingPageState createState() => _RentingPageState();
}

class _RentingPageState extends State<RentingPage> {
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController rentAmountController = TextEditingController();
  String selectedDuration = 'One Month'; // Default selected duration
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = double.parse(widget.oneDayRent) * 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
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
          'Renting Confirmation',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Image.network(
                widget.img,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "\$${widget.oneDayRent} /Day",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    iconSize: 24,
                    elevation: 16,
                    borderRadius: BorderRadius.circular(16),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                    underline: null,
                    dropdownColor: Colors.grey.shade200,
                    value: selectedDuration,
                    items: [
                      'One Month',
                      'Six Months',
                      'One Year',
                    ].map((String duration) {
                      return DropdownMenuItem<String>(
                        value: duration,
                        child: Text(duration),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedDuration = value!;
                        calculateTotalAmount();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RentingConfirmationButton(carId: widget.carID),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotalAmount() {
    // Implement your logic to calculate total amount based on the selected duration
    // You may adjust the calculation based on your actual pricing strategy
    double oneDayRent = double.parse(widget.oneDayRent);
    switch (selectedDuration) {
      case 'One Month':
        totalAmount = oneDayRent * 30;
        break;
      case 'Six Months':
        totalAmount = oneDayRent * 30 * 6;
        break;
      case 'One Year':
        totalAmount = oneDayRent * 30 * 12;
        break;
    }
  }
}
