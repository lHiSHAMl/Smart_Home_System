import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:may_iot/homepage.dart';
import 'package:may_iot/signin.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for authentication state
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // User is signed in
            return HomePage();
          } else {
            // User is not signed in
            return Signin();
          }
        },
      ),
    );
  }
}
