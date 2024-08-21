import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cars/themes/theme_notifier.dart';
import 'package:cars/pages/widgets/secondary_widgets/about_us_activity.dart';
import 'package:cars/pages/widgets/secondary_widgets/history_activity.dart';
import 'package:cars/pages/widgets/secondary_widgets/account_activity.dart';

class ProfileActivity extends StatefulWidget {
  const ProfileActivity({super.key});

  @override
  State<ProfileActivity> createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  User? user;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  void showThemeDialog(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  themeNotifier.toggleTheme();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  themeNotifier.toggleTheme();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('System Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
          'Profile',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontFamily: 'Roboto',
            letterSpacing: 3,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      VerticalDivider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      _buildCurrentUserData(),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Account'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AccountActivity();
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('History'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HistoryActivity();
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Theme'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showThemeDialog(context, themeNotifier);
                        },
                      ),
                      ListTile(
                        title: const Text('Language'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('About Us'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AboutUsActivity();
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Terms & Conditions'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Privacy Policy'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Contact Us'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentUserData() {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream =
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots();
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey));
          }

          final Map<String, dynamic>? userData = snapshot.data?.data();

          if (userData != null) {
            return Center(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 40,
                    backgroundImage: NetworkImage('${userData['photoUrl']}'),
                  ),
                  const SizedBox(width: 25),
                  Column(
                    children: [
                      Text(
                        '${userData['firstName']} ${userData['lastName']}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        '${userData['email']}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: 22,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Text('No user data found',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey));
          }
        },
      );
    } else {
      return const Text('Not logged in',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey));
    }
  }
}
