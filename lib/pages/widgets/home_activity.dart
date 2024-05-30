import 'package:cars/components/car_series_stream.dart';
import 'package:cars/themes/theme_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import the new file

class HomeActivity extends StatefulWidget {
  const HomeActivity({super.key});

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  late Map<String, dynamic>? userData;
  late bool isLoading;
  late String loadingError;

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

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
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
            radius: 20,
            backgroundImage: NetworkImage('${userData!['photoUrl']}'),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(width: 10),
          Text(
            '${userData!['firstName']} ${userData!['lastName']}'.toUpperCase(),
            style: const TextStyle(
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
      return Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 2),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _buildWelcomeSection(isDarkMode),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:
                  CarSeriesStream(tradeMark: 'Ferrari', modelName: 'Special'),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: CarSeriesStream(tradeMark: 'Ferrari', modelName: 'Range'),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: CarSeriesStream(tradeMark: 'Ferrari', modelName: 'Icona'),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: CarSeriesStream(tradeMark: 'BMW', modelName: 'm'),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: CarSeriesStream(tradeMark: 'BMW', modelName: 'i'),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: CarSeriesStream(tradeMark: 'BMW', modelName: 'x'),
            ),
          ],
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Find your perfect car today!',
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
