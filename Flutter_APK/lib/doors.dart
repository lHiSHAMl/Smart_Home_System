import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'MQTT (1).dart';

class DoorWindowControl extends StatefulWidget {
  const DoorWindowControl({Key? key}) : super(key: key);

  @override
  _DoorWindowControlState createState() => _DoorWindowControlState();
}

class _DoorWindowControlState extends State<DoorWindowControl> {
  int _currentIndex = 0; // Default index for this page
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  
  // State variables to keep track of door/window states
  bool _isMainDoorOpen = false; // Main door
  bool _isGarageDoorOpen = false; // Garage door
  bool _isWindowOpen = false; // Window
 
final _topicController = TextEditingController();
final _messageController = TextEditingController();
final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }
  void _toggleMainDoor() {
    String message = _isMainDoorOpen ? 'close' : 'open';
    mqttClientWrapper.publishMessage('Home/Main_Door', message);
    setState(() {
      _isMainDoorOpen = !_isMainDoorOpen;
    });
  }

  void _toggleGarageDoor() {
    String message = _isGarageDoorOpen ? 'close' : 'open';
    mqttClientWrapper.publishMessage('Home/Garage_Door', message);
    setState(() {
      _isGarageDoorOpen = !_isGarageDoorOpen;
    });
  }

  void _toggleWindow() {
    String message = _isWindowOpen ? 'close' : 'open';
    mqttClientWrapper.publishMessage('Home/Window', message);
    setState(() {
      _isWindowOpen = !_isWindowOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Control Panel',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.control_camera,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              // Image Banner
              Center(
                child: Image.asset(
                  'assets/images/banner.png',
                  scale: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Title for Control Devices
              Center(
                child: const Text(
                  'Control Devices',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'DOORS & WINDOWS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Main Door Control centered
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _controlCardMenu(
                    icon: Icons.door_sliding_sharp,
                    title: 'Main Door',
                    isOpen: _isMainDoorOpen,
                    toggleAction: _toggleMainDoor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Garage Door and Window Controls
              Row(
                children: [
                  Expanded(
                    child: _controlCardMenu(
                      icon: Icons.garage_rounded,
                      title: 'Garage Door',
                      isOpen: _isGarageDoorOpen,
                      toggleAction: _toggleGarageDoor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _controlCardMenu(
                      icon: Icons.window,
                      title: 'Window',
                      isOpen: _isWindowOpen,
                      toggleAction: _toggleWindow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              key: _bottomNavigationKey,
              index: _currentIndex,
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
                setState(() {
                  _currentIndex = index;  // Update the current index
                });

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
                  default:
                    break;
                }
              },
            )),
      ),
    );
  }

  Widget _controlCardMenu({
    required String title,
    required IconData icon,
    required bool isOpen,
    required VoidCallback toggleAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.indigo),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: toggleAction,
            child: Text(isOpen ? 'Close' : 'Open'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 237, 239, 247),
            ),
          ),
        ],
      ),
    );
  }
}
