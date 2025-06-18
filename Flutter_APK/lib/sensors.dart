import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class sensors extends StatefulWidget {
  const sensors({Key? key}) : super(key: key);

  @override
  _sensorsState createState() => _sensorsState();
}

class _sensorsState extends State<sensors> {
  late MqttServerClient client;
  String fireSensorData = 'No Data';
  String gasSensorData = 'No Data';
  String waterSensorData = 'No Data';
  String motionSensorData = 'No Data';
  
  int _currentIndex = 1; // Default index for Sensors page
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setupMqttClient();
  }

  Future<void> setupMqttClient() async {
  client = MqttServerClient.withPort('9e76f359454b4390a6aee8af043690d7.s1.eu.hivemq.cloud', 'Ali Soliman', 8883); // Use port 8883 for TLS/SSL
  client.logging(on: true);
  client.keepAlivePeriod = 20;
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  // Set the client to use secure connection
  client.secure = true;
  client.securityContext = SecurityContext.defaultContext; // Use default SSL context or provide custom certificates if needed

  // Set up credentials
  client.connectionMessage = MqttConnectMessage()
      .withClientIdentifier('Ali Soliman')
      .withWillTopic('home/last_will')
      .withWillMessage('Client disconnected')
      .withWillQos(MqttQos.atMostOnce)
      .authenticateAs('Ali Soliman', 'Ali.Sief1521')
      .startClean();

  try {
    await client.connect();
  } catch (e) {
    print('Exception during connection: $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('MQTT client connected');
    client.subscribe('home/fire_sensor', MqttQos.atMostOnce);
    client.subscribe('home/gas_sensor', MqttQos.atMostOnce);
    client.subscribe('home/water_sensor', MqttQos.atMostOnce);
    client.subscribe('home/motion_sensor', MqttQos.atMostOnce);
  } else {
    print('Connection failed');
  }

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    switch (c[0].topic) {
      case 'home/fire_sensor':
        setState(() {
          fireSensorData = message;
        });
        break;
      case 'home/gas_sensor':
        setState(() {
          gasSensorData = message;
        });
        break;
      case 'home/water_sensor':
        setState(() {
          waterSensorData = message;
        });
        break;
      case 'home/motion_sensor':
        setState(() {
          motionSensorData = message;
        });
        break;
    }
  });
}
  void onConnected() {
    print('Connected');
    client.subscribe('home/fire_sensor', MqttQos.atMostOnce);
    client.subscribe('home/gas_sensor', MqttQos.atMostOnce);
    client.subscribe('home/water_sensor', MqttQos.atMostOnce);
    client.subscribe('home/motion_sensor', MqttQos.atMostOnce);
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void pong() {
    print('Ping response received');
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
                    'HI ALI',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    // Add back the image
                    Center(
                      child: Image.asset(
                        'assets/images/banner.png',
                        scale: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Smart Home',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'SENSORS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sensorCardMenu(
                          icon: Icons.fire_extinguisher,
                          title: 'Fire Sensor',
                          sensorData: fireSensorData,
                        ),
                        _sensorCardMenu(
                          icon: Icons.gas_meter,
                          title: 'Gas Sensor',
                          sensorData: gasSensorData,
                          fontColor: Colors.indigo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sensorCardMenu(
                          icon: Icons.water,
                          title: 'Water Sensor',
                          sensorData: waterSensorData,
                        ),
                        _sensorCardMenu(
                          icon: Icons.person,
                          title: 'Motion Sensor',
                          sensorData: motionSensorData,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 0.0), // Adjust the padding as needed
        child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.transparent, // Make container background transparent
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  blurRadius: 10, // Blur radius
                  spreadRadius: 2, // Spread radius
                  offset: Offset(0, 4), // Offset from the bar
                ),
              ],
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30)), // Make edges more oval
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
              animationCurve: Curves
                  .easeInOut, // Adjust the curve to make the animation smoother
              animationDuration: Duration(
                  milliseconds:
                      300), // Adjust the duration to slow down the animation
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
)),
      ),
    );
  }

  Widget _sensorCardMenu({
    required String title,
    required IconData icon,
    required String sensorData,
    Color color = Colors.white,
    Color fontColor = Colors.indigo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: 156,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: fontColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
          ),
          const SizedBox(height: 10),
          Text(
            sensorData,
            style: TextStyle(color: fontColor),
          ),
        ],
      ),
    );
  }
}
