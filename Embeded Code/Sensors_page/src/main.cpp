#include <WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>

// WiFi credentials
char ssid[] = "WE_9BFF74";
char pass[] = "m2315798";

//---- HiveMQ Cloud Broker settings
const char* mqtt_server = "9e76f359454b4390a6aee8af043690d7.s1.eu.hivemq.cloud";
const char* mqtt_username = "Ali Soliman";
const char* mqtt_password = "Ali.Sief1521";
const int mqtt_port = 8883;

WiFiClientSecure espClient;
PubSubClient client(espClient);

// HiveMQ Cloud Let's Encrypt CA certificate
static const char *root_ca PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE (500)
char msg[MSG_BUFFER_SIZE];
int value = 0;

void setup_wifi() {
delay(10);
// We start by connecting to a WiFi network
Serial.println();
Serial.print("Connecting to ");
Serial.println(ssid);

WiFi.mode(WIFI_STA);
WiFi.begin(ssid, pass);

while (WiFi.status() != WL_CONNECTED) {
delay(500);
Serial.print(".");
}

randomSeed(micros());

Serial.println("");
Serial.println("WiFi connected");
Serial.println("IP address: ");
Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
Serial.print("Message arrived [");
Serial.print(topic);
Serial.print("] ");
for (int i = 0; i < length; i++) {
Serial.print((char)payload[i]);
}
Serial.println();
}

void reconnect() {
// Loop until we’re reconnected
while (!client.connected()) {
Serial.print("Attempting MQTT connection… ");
String clientId = "ESP32Client";
// Attempt to connect
if (client.connect(clientId.c_str(), mqtt_username, mqtt_password)) {
Serial.println("connected!");
// Once connected, publish an announcement...
client.publish("ESP32/status", "connected");
// ... and resubscribe
//client.subscribe("Flutter/to/ESP");
} else {
Serial.print("failed, rc = ");
Serial.print(client.state());
Serial.println(" try again in 5 seconds");
// Wait 5 seconds before retrying
delay(5000);
}
}
}
const int flameSensorPin = 13; // Pin connected to DOUT of flame sensor
const int gasSensorPin = 36; // Pin connected to AOUT of gas sensor
const int buzzerPin = 12; // Pin connected to buzzer
const int raindropSensorPin = 14; // Pin connected to DOUT of raindrop sensor
const int pirSensorPin = 15; // Pin connected to OUT of PIR sensor

int flameSensorValue = 0; // Variable to store the flame sensor value
int gasSensorValue = 0; // Variable to store the gas sensor value
int raindropSensorValue = 0; // Variable to store the raindrop sensor value
int pirSensorValue = 0; // Variable to store the PIR sensor value

void setup() {
delay(500);
// When opening the Serial Monitor, select 9600 Baud
Serial.begin(9600);
pinMode(flameSensorPin, INPUT); // Set flame sensor pin as input
pinMode(gasSensorPin, INPUT); // Set gas sensor pin as input
pinMode(buzzerPin, OUTPUT); // Set buzzer pin as output
pinMode(raindropSensorPin, INPUT); // Set raindrop sensor pin as input
pinMode(pirSensorPin, INPUT); // Set PIR sensor pin as input

delay(500);
setup_wifi();
espClient.setCACert(root_ca);
client.setServer(mqtt_server, mqtt_port);
client.setCallback(callback);
}

void loop() {
if (!client.connected()) {
reconnect();
}
client.loop();
flameSensorValue = digitalRead(flameSensorPin); // Read the value from the flame sensor
gasSensorValue = analogRead(gasSensorPin); // Read the value from the gas sensor
raindropSensorValue = digitalRead(raindropSensorPin); // Read the value from the raindrop sensor
pirSensorValue = digitalRead(pirSensorPin); // Read the value from the PIR sensor

            //____ FLAME_______
  if (flameSensorValue == LOW) {    
    client.publish("home/fire_sensor", "FLAME detected!");
    digitalWrite(buzzerPin,HIGH);
    delay(1000);
  } else {    
    client.publish("home/fire_sensor", "No FLAME detected.");
    digitalWrite(buzzerPin,LOW);
  }
            //_____MQ4_______
  if (gasSensorValue > 1400) {    
    client.publish("home/gas_sensor", "GAS detected!");
    digitalWrite(buzzerPin,HIGH);
    delay(1000);
  } else {    
    client.publish("home/gas_sensor", "No GAS detected.");
    digitalWrite(buzzerPin,LOW);
  }

          //_____RAIN_______
  if (raindropSensorValue == LOW) {    
    client.publish("home/water_sensor", "RAIN detected!");
    digitalWrite(buzzerPin,HIGH);
    delay(1000);
  } else {    
    client.publish("home/water_sensor", "No RAIN detected.");
    digitalWrite(buzzerPin,LOW);
  }

            //_____MOTION_______
  if (pirSensorValue == HIGH) {    
    client.publish("home/motion_sensor", "MOTION detected!");
    digitalWrite(buzzerPin,HIGH);
    delay(1000);
  } else {    
    client.publish("home/motion_sensor", "No MOTION detected.");
    digitalWrite(buzzerPin,LOW);
  }
  delay(1000); // Wait for a second before reading again

}