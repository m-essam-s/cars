import 'package:cars/pages/widgets/renting_page_activity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class BookmarksActivity extends StatefulWidget {
  const BookmarksActivity({Key? key}) : super(key: key);

  @override
  _BookmarksActivityState createState() => _BookmarksActivityState();
}

class _BookmarksActivityState extends State<BookmarksActivity> {
  late final User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  List<Stream<QuerySnapshot>> mergeFirestoreCollections() {
    var stream1 = FirebaseFirestore.instance
        .collection('cars')
        .doc('BMW')
        .collection('m-series')
        .snapshots();
    var stream2 = FirebaseFirestore.instance
        .collection('cars')
        .doc('BMW')
        .collection('x-series')
        .snapshots();
    var stream3 = FirebaseFirestore.instance
        .collection('cars')
        .doc('BMW')
        .collection('i-series')
        .snapshots();
    var stream4 = FirebaseFirestore.instance
        .collection('cars')
        .doc('Ferrari')
        .collection('IconaSeries')
        .snapshots();
    var stream5 = FirebaseFirestore.instance
        .collection('cars')
        .doc('Ferrari')
        .collection('RangeSeries')
        .snapshots();
    var stream6 = FirebaseFirestore.instance
        .collection('cars')
        .doc('Ferrari')
        .collection('SpecialSeries')
        .snapshots();

    return [stream1, stream2, stream3, stream4, stream5, stream6];
  }

  List<DocumentSnapshot> filterCars(
      List<DocumentSnapshot> documents, String searchText) {
    return documents.where((document) {
      final String name = document.get('name') ?? '';
      return name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
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
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Colors.grey[500]!,
            fontFamily: 'Roboto',
            letterSpacing: 3,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: _user != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('bookmarks')
                      .doc(_user.uid)
                      .collection('cars')
                      .snapshots(),
                  builder: (context, bookmarkSnapshot) {
                    if (bookmarkSnapshot.hasError) {
                      return Text('Error: ${bookmarkSnapshot.error}');
                    }

                    if (bookmarkSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<DocumentSnapshot> bookmarkedCars =
                        bookmarkSnapshot.data!.docs;

                    return StreamBuilder<List<QuerySnapshot>>(
                      stream: Rx.combineLatestList<QuerySnapshot>(
                          mergeFirestoreCollections()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final List<QuerySnapshot> snapshots = snapshot.data!;
                        final List<DocumentSnapshot> allCars = snapshots
                            .expand((snapshot) => snapshot.docs)
                            .toList();

                        // Filter the cars based on bookmarked car IDs
                        final List<DocumentSnapshot> bookmarkedCarData = allCars
                            .where((car) => bookmarkedCars.any(
                                (bookmark) => bookmark.get('carId') == car.id))
                            .toList();

                        if (bookmarkedCarData.isEmpty) {
                          return const Center(
                              child: Text('No bookmarked cars.'));
                        }

                        return ListView.builder(
                          itemCount: bookmarkedCarData.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot document =
                                bookmarkedCarData[index];
                            final String name = document.get('name') ?? '';
                            final String img = document.get('img') ?? '';
                            final String oneDayRent =
                                document.get('1dayrent') ?? '';
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
                                        img: img,
                                        oneDayRent: oneDayRent,
                                        status: status,
                                        carID: carId,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.grey[100],
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Image.network(img),
                                          Text(
                                            "$status   $oneDayRent Dollars /Day",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.grey[700]!,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 0,
                                        right: 0,
                                        child: Text(
                                          name.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500]!,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('bookmarks')
                                                .doc(_user.uid)
                                                .collection('cars')
                                                .doc(carId)
                                                .delete();
                                          },
                                          icon: const Icon(
                                              Icons.delete_outlined,
                                              color: Colors.red,
                                              size: 30.0),
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
                    );
                  },
                ),
              ),
            )
          : const Center(
              child: Text('Please log in to view favorites.'),
            ),
    );
  }
}
