import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:may_iot/LEDs.dart';
import 'package:may_iot/doors.dart';
import 'package:may_iot/profile.dart';
import 'package:may_iot/sensors.dart';
import 'signup.dart';
import 'signin.dart';
import 'homepage.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'signup',
      routes: {
        'signup': (context) => Signup(),
        'signin': (context) => Signin(),
        'home': (context) => HomePage(),
        'sensors':(context) => sensors(),
        'doors':(context) => DoorWindowControl(),
        'LEDs' :(context) => LEDs(),
        'profile' : (context) => profile(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => Signup());
      },
    );
  }
}
