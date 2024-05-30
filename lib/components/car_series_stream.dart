import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'renting_page_activity.dart';

class CarSeriesStream extends StatelessWidget {
  final String tradeMark;
  final String modelName;

  const CarSeriesStream({
    super.key,
    required this.tradeMark,
    required this.modelName,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cars')
          .doc(tradeMark)
          .collection(modelName)
          .orderBy('name')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];
        if (documents.isEmpty) {
          return const Center(child: Text('No cars found.'));
        }

        return Column(
          children: [
            Row(
              children: [
                Text(
                  '$tradeMark ${modelName[0].toUpperCase()}${modelName.substring(1)} Series',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.8,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final String name = document.get('name') ?? '';
                  final String imageURL = document.get('img') ?? '';
                  final String oneDayRent = document.get('1dayrent') ?? '';
                  final String status = document.get('status') ?? '';
                  final String carId = document.id;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RentingPage(
                              name: name,
                              img: imageURL,
                              oneDayRent: oneDayRent,
                              status: status,
                              carID: carId,
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        width: 210,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  imageURL,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    name.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
