import 'package:cars/components/renting_page_activity.dart';
import 'package:cars/components/build_bookmark_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeriesActivity extends StatefulWidget {
  final String title;
  final String tradeMark;
  final String modelName;

  const SeriesActivity({
    super.key,
    required this.title,
    required this.tradeMark,
    required this.modelName,
  });

  @override
  State<SeriesActivity> createState() => _SeriesActivityState();
}

class _SeriesActivityState extends State<SeriesActivity> {
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
            size: 35,
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
            letterSpacing: 3,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
        child: Container(
          padding:
              const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('cars')
                .doc(widget.tradeMark)
                .collection(widget.modelName)
                .orderBy('name')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Center(child: Text('No cars found.'));
              }

              return ListView.builder(
                // padding: const EdgeInsets.all(8),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Image.network(imageURL),
                              ],
                            ),
                            Positioned(
                              top: 10,
                              left: 0,
                              right: 0,
                              child: Text(
                                name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              left: 0,
                              right: 0,
                              child: Text(
                                "$status   \$$oneDayRent /Day",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: BookmarkIconButton(
                                carId: carId,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
