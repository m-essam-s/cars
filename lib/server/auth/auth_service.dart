import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<bool> isRegisteredUser(String email) async {
    // check if user is registered
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: 'password');
      // ignore: avoid_print
      print('User is registered');
      await userCredential.user!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('User is not registered');
        return false;
      }
      // ignore: avoid_print
      print('Error: $e');
      return false;
    }
  }
}
