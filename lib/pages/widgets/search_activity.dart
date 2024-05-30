import 'package:cars/components/renting_page_activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cars/data/firestore_streams.dart';

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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Search Cars',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontFamily: 'Roboto',
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
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Apply border radius here
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Maintain same radius
                ),
                prefixIcon: const Icon(Icons.search, size: 25),
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
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Image.network(imageURL),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  Text(
                                    status,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200,
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.italic,
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
