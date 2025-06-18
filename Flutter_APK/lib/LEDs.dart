import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'MQTT (1).dart';
class LEDs extends StatefulWidget {
  const LEDs({Key? key}) : super(key: key);

  @override
  _LedControlState createState() => _LedControlState();
}

class _LedControlState extends State<LEDs> {
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  int _currentIndex = 3; // Default index for the LEDs page
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  
  // State variables to keep track of LED states
  bool _isLed1On = false;
  bool _isLed2On = false;
  bool _isLed3On = false;

final _topicController = TextEditingController();
final _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }

  void _toggleLed1() {
    String message = _isLed1On ? 'off' : 'on';
    mqttClientWrapper.publishMessage('LED/Garage', message);
    setState(() {
      _isLed1On = !_isLed1On;
    });
  }

  void _toggleLed2() {
    String message = _isLed2On ? 'off' : 'on';
    mqttClientWrapper.publishMessage('LED/Kitchen', message);
    setState(() {
      _isLed2On = !_isLed2On;
    });
  }

  void _toggleLed3() {
    String message = _isLed3On ? 'off' : 'on';
    mqttClientWrapper.publishMessage('LED/Living', message);
    setState(() {
      _isLed3On = !_isLed3On;
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
              // Add the image back
              Center(
                child: Image.asset(
                  'assets/images/banner.png',
                  scale: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Title for control devices
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
                'LED CONTROLS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // LED control cards
              Row(
                children: [
                  Expanded(
                    child: _controlCardMenu(
                      icon: Icons.lightbulb,
                      title: 'Garage',
                      isOn: _isLed1On,
                      toggleAction: _toggleLed1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _controlCardMenu(
                      icon: Icons.lightbulb,
                      title: 'Kitchen',
                      isOn: _isLed2On,
                      toggleAction: _toggleLed2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _controlCardMenu(
                    icon: Icons.lightbulb,
                    title: 'Living',
                    isOn: _isLed3On,
                    toggleAction: _toggleLed3,
                  ),
                ),
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
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
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
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _controlCardMenu({
    required String title,
    required IconData icon,
    required bool isOn,
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
            child: Text(isOn ? 'Turn Off' : 'Turn On'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 237, 239, 247),
            ),
          ),
        ],
      ),
    );
  }
}
