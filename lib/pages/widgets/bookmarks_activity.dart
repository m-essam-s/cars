import 'package:cars/components/renting_page_activity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cars/data/firestore_streams.dart';

class BookmarksActivity extends StatefulWidget {
  const BookmarksActivity({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookmarksActivityState createState() => _BookmarksActivityState();
}

class _BookmarksActivityState extends State<BookmarksActivity> {
  late final User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
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
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
            letterSpacing: 3,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: _user != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('bookmarks')
                    .doc(_user.uid)
                    .collection('cars')
                    .snapshots(),
                builder: (context, bookmarkSnapshot) {
                  if (bookmarkSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${bookmarkSnapshot.error}'));
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
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<QuerySnapshot> snapshots = snapshot.data!;
                      final List<DocumentSnapshot> allCars = snapshots
                          .expand((snapshot) => snapshot.docs)
                          .toList();

                      final List<DocumentSnapshot> bookmarkedCarData =
                          allCars.where((car) {
                        return bookmarkedCars
                            .any((bookmark) => bookmark.get('carId') == car.id);
                      }).toList();

                      if (bookmarkedCarData.isEmpty) {
                        return const Center(child: Text('No bookmarked cars.'));
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        img,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      name.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "$status   $oneDayRent Dollars /Day",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
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
                                          size: 30.0,
                                        ),
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
            )
          : const Center(child: Text('Please log in to view favorites.')),
    );
  }
}
