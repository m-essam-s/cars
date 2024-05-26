import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:cars/components/build_card.dart';
import 'package:cars/pages/widgets/about_us_activity.dart';
import 'package:cars/pages/widgets/history_activity.dart';
import 'package:cars/pages/auth/reset_pass_page.dart';
import 'package:cars/pages/auth/auth_page.dart';
import 'package:cars/pages/widgets/edit_profile_activity.dart';
import 'package:cars/themes/theme_notifier.dart'; // Import ThemeNotifier

class ProfileActivity extends StatefulWidget {
  ProfileActivity({Key? key}) : super(key: key);

  @override
  State<ProfileActivity> createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  Future<void> _confirmSignOut(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                } catch (e) {
                  // Handle errors gracefully, e.g., show an error message
                }
              },
              child:
                  const Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAccountDeletion(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Are you sure you want to delete your account?'),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .delete();
                  await FirebaseAuth.instance.currentUser!.delete();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (error) {
                  print('Error deleting account: $error');
                  // Handle error gracefully, e.g., show a snackbar
                }
              },
              child: const Text('Delete Account',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
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
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: [
                const SizedBox(height: 100),
                _buildCurrentUserData(),
                const SizedBox(height: 25),
                BuildCard(
                  text: 'History',
                  icon: Icons.history,
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
                BuildCard(
                  text: 'About Us',
                  icon: Icons.info_outline,
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
                BuildCard(
                  text: 'Edit Profile',
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfileActivity(
                            onTap: () {},
                          );
                        },
                      ),
                    );
                  },
                ),
                BuildCard(
                  text: 'Reset Password',
                  icon: Icons.lock_reset_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetPassword(
                            onTap: () {},
                          );
                        },
                      ),
                    );
                  },
                ),
                BuildCard(
                  text: 'Sign Out',
                  icon: Icons.logout,
                  onTap: () {
                    _confirmSignOut(context);
                  },
                ),
                BuildCard(
                  text: 'Delete Account',
                  icon: Icons.delete_forever_outlined,
                  onTap: () {
                    _confirmAccountDeletion(context);
                  },
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    radius: 70,
                    backgroundImage: NetworkImage('${userData['photoUrl']}'),
                  ),
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
