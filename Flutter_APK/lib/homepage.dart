import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Set default index to the middle item
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned(
            child: Image.asset(
              'assets/images/background.png', // Use your image path here
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.0), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // Content overlay
          Padding(
            padding: EdgeInsets.all(16.0), // Padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Hello, How are you?\nLet me start by telling you what's this application does and how it works:\n\n"
                    "1. Control all the doors and windows in your home with a click of a button.\n"
                    "2. Monitor all the sensor readings implemented in your house for comfort and safety.\n"
                    "3. Control all the lights around your home with the same click of a button.\n"
                    "4. View your profile and all the data you've entered during sign-up.\n\n"
                    "Hope you have a great experience with our app!\n\n- dev.Ali Soliman",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 0.0), // Adjust the padding as needed
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Make container background transparent
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: 10, // Blur radius
                spreadRadius: 2, // Spread radius
                offset: Offset(0, 4), // Offset from the bar
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Make edges more oval
          ),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: _currentIndex,
            height: 65.0, // Increase height to make it more oval-like
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
            animationCurve: Curves.easeInOut, // Adjust the curve to make the animation smoother
            animationDuration: Duration(milliseconds: 300), // Adjust the duration to slow down the animation
            onTap: (index) {
              setState(() {
                _currentIndex = index;  // Update the current index
              });

              switch (index) {
                case 0:
                  // Navigate to Door control page
                  Navigator.pushReplacementNamed(context, 'doors');
                  break;
                case 1:
                  // Navigate to Sensors page
                  Navigator.pushReplacementNamed(context, 'sensors');
                  break;
                case 2:
                  // Navigate to Home page
                  Navigator.pushReplacementNamed(context, 'home');
                  break;
                case 3:
                  // Navigate to LED control page
                  Navigator.pushReplacementNamed(context, 'LEDs');
                  break;
                case 4:
                  // Navigate to Profile page
                  Navigator.pushReplacementNamed(context, 'profile');
                  break;
                default:
                  // Fallback if no case matches
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
