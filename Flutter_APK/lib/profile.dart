import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<profile> {
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();

      setState(() {
        firstName = userDoc['first_name'] ?? '';
        lastName = userDoc['last_name'] ?? '';
      });
    }
  }

  Future<void> _launchGitHub() async {
    const url =
        'https://github.com/AliySoliman/Smart_Home'; // Replace with your GitHub profile URL
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch $url'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      print('Error launching URL: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(
      msg: "طب س س سلام سلام",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.6),
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pushReplacementNamed(context, 'signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Image.asset(
              'assets/images/background.png', // Use your image path here
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 60),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$firstName $lastName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 180),
              Container(
                color: Colors.white24.withOpacity(0.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.indigo),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('home');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help, color: Colors.indigo),
                      title: Text('Help & Support'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('home');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info, color: Colors.indigo),
                      title: Text('About'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('home ');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.indigo),
                      title: Text('Logout'),
                      onTap: _logout,
                    ),
                    ListTile(
                      leading: Icon(Icons.link, color: Colors.indigo),
                      title: Text('GitHub'),
                      onTap: _launchGitHub,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: CurvedNavigationBar(
            index: 4,
            height: 65.0,
            items: <Widget>[
              Icon(Icons.door_sliding_outlined, size: 30),
              Icon(Icons.sensors_rounded, size: 30),
              Icon(Icons.home_filled, size: 30),
              Icon(Icons.light, size: 30),
              Icon(Icons.person, size: 30),
            ],
            color: Colors.white,
            buttonBackgroundColor: Color.fromRGBO(143, 148, 251, 1),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, 'doors');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, 'sensors');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, 'home');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, 'LEDs');
                  break;
                case 4:
                  Navigator.pushReplacementNamed(context, 'profile');
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
