import 'package:cars/components/build_bookmark_icon.dart';
import 'package:cars/components/build_rent_botton.dart';
import 'package:flutter/material.dart';

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
        title: const Text(
          'Renting Confirmation',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto',
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          BookmarkIconButton(carId: widget.carID),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.network(
                widget.img,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
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
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
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
            ),
            const SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
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
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RentingConfirmationButton(carId: widget.carID),
            ),
          ],
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
