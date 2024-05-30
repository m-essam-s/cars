import 'package:cars/pages/auth/auth_page.dart'; // Import the sign-in page
import 'package:cars/pages/auth/reset_pass_page.dart';
import 'package:cars/pages/widgets/secondary_widgets/edit_profile_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountActivity extends StatelessWidget {
  const AccountActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileActivity(
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Reset Password'),
            trailing: const Icon(Icons.reset_tv),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPassword(
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            trailing: const Icon(Icons.logout),
            onTap: () {
              _confirmSignOut(context);
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            trailing: const Icon(Icons.delete_forever_outlined),
            onTap: () {
              _confirmAccountDeletion(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  // Navigate to the sign-in page after signing out
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthPage()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
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
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .delete();
                  await currentUser!.delete();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  // Navigate to the sign-in page after deleting the account
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthPage()));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $error')),
                  );
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
}
