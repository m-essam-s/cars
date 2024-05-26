import 'package:cars/Pages/widgets/renting_page_activity.dart';
import 'package:cars/components/build_bookmark_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cars/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class SearchActivity extends StatefulWidget {
  const SearchActivity({Key? key}) : super(key: key);

  @override
  State<SearchActivity> createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
  late List<Stream<QuerySnapshot>> streams;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    streams = mergeFirestoreCollections();
    _searchController = TextEditingController();
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
        title: Text(
          'Find your Car',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[500]!,
            fontFamily: 'Roboto',
            letterSpacing: 3,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Trigger rebuild on text change
              },
              decoration: InputDecoration(
                hintText: 'Search for a car...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                fillColor: Colors.grey.shade100,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100),
                  borderRadius:
                      BorderRadius.circular(15), // Apply border radius here
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius:
                      BorderRadius.circular(15), // Maintain same radius
                ),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey[500], size: 25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: StreamBuilder<List<QuerySnapshot>>(
                  stream: Rx.combineLatestList<QuerySnapshot>(streams),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<QuerySnapshot> snapshots = snapshot.data!;
                    final List<DocumentSnapshot> allDocuments =
                        snapshots.expand((snapshot) => snapshot.docs).toList();

                    // Filter documents based on search text
                    final searchText = _searchController.text;
                    final List<DocumentSnapshot> filteredDocuments =
                        filterCars(allDocuments, searchText);

                    if (filteredDocuments.isEmpty) {
                      return const Center(child: Text('No cars found.'));
                    }

                    return GridView.builder(
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        final document = filteredDocuments[index];
                        final String name = document.get('name') ?? '';
                        final String imageURL = document.get('img') ?? '';
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
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.network(imageURL),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 12),
                                        child: Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.grey[700]!,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        Text(
                                          "$oneDayRent Dollars /Day",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200,
                                            color: isDarkMode
                                                ? Colors.grey[300]
                                                : Colors.grey[700]!,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        Text(
                                          status,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200,
                                            color: isDarkMode
                                                ? Colors.grey[300]
                                                : Colors.grey[700]!,
                                            fontFamily: 'Roboto',
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
