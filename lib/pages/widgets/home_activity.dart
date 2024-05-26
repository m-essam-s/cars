// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cars/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cars/pages/widgets/build_cars_widgets_avtivity.dart';
import 'package:cars/themes/theme_notifier.dart';

class HomeActivity extends StatefulWidget {
  const HomeActivity({Key? key}) : super(key: key);

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  late Map<String, dynamic>? userData;
  late bool isLoading;
  late String loadingError;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        title: _buildAppBarTitle(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
      ),
      body: _buildBody(isDarkMode),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingError.isNotEmpty) {
      return Center(
        child: Text(
          'Error loading data: $loadingError',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildWelcomeSection(isDarkMode),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildFerrariSection(isDarkMode),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildBMWSection(isDarkMode),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildWelcomeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome,'.toUpperCase(),
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${userData!['firstName']} ${userData!['lastName']}',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFerrariSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ferrari Collections',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const Image(
            image: NetworkImage(
                'https://cdn.ferrari.com/cms/network/media/img/resize/6195238a231148389a65f8f4-f150bdcoverthree1920x1080?width=1920&height=1080'),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FFerrari%2FFerrari.png?alt=media&token=3f4f907a-cd06-49aa-9257-6089a33a6163',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'Ferrari Icona Series',
                          tradeMark: 'Ferrari',
                          modelName: 'IconaSeries',
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FFerrari%2FFerrari.png?alt=media&token=3f4f907a-cd06-49aa-9257-6089a33a6163',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'Ferrari Range Series',
                          tradeMark: 'Ferrari',
                          modelName: 'RangeSeries',
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FFerrari%2FFerrari.png?alt=media&token=3f4f907a-cd06-49aa-9257-6089a33a6163',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'Ferrari Special Series',
                          tradeMark: 'Ferrari',
                          modelName: 'SpecialSeries',
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBMWSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMW Collections',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const Image(
            image: NetworkImage(
                'https://www.bmw-m.com/content/dam/bmw/marketBMW_M/common/home/Visual-Snow-Individual-16zu9-thumbnail.jpg/jcr:content/renditions/cq5dam.resized.img.1680.large.time1701948150141.jpg'),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FBMW%2FBMW-M-Logo.png?alt=media&token=6abac1c5-69c3-4a94-82ff-0398993a6536',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'BMW M Series',
                          tradeMark: 'BMW',
                          modelName: 'm-series',
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FBMW%2FBMW-I-Logo.png?alt=media&token=ac75cf59-b9c1-471e-b069-057983be1565',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'BMW I Series',
                          tradeMark: 'BMW',
                          modelName: 'i-series',
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              SquareTile(
                imagePath:
                    'https://firebasestorage.googleapis.com/v0/b/hackathon-masters.appspot.com/o/Cars%2FBMW%2FBMW-xm-logo.png?alt=media&token=61921001-3ca3-4e68-887c-efd6c23b8ae4',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SeriesActivity(
                          title: 'BMW X Series',
                          tradeMark: 'BMW',
                          modelName: 'x-series',
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    if (isLoading) {
      return const Text('Loading...');
    } else if (loadingError.isNotEmpty) {
      return Text(
        'Error: $loadingError',
        style: const TextStyle(color: Colors.red),
      );
    } else if (userData != null) {
      return Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            radius: 20,
            backgroundImage: NetworkImage('${userData!['photoUrl']}'),
          ),
          const SizedBox(width: 10),
          Text(
            '${userData!['firstName']} ${userData!['lastName']}'.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return const Text('Not logged in');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadingError = '';
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();

        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data();
            isLoading = false;
          });
        } else {
          setState(() {
            loadingError =
                'User data not found for user ID: ${currentUser.uid}';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          loadingError = 'Error loading user data: $e';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        loadingError = 'Current user is null';
        isLoading = false;
      });
    }
  }
}
