#include <DHT.h>
#include <DHT_U.h>
#include <ArduinoJson.h>

#define DHTPIN 2
#define DHTTYPE    DHT11

// Temperature and humidity sensor data
DHT dht(DHTPIN, DHTTYPE);

// Light sensor data
int lightSensor = A0;
float lightMax = 1000;
float lightMin = 25;

// Soil sensor data
int soilSensor = A1;
float soilDry = 573;
float soilWet = 336;

// Serial data for communication between uno and nodemcu
String message = "";
bool messageReady = false;

void setup() {
  // Start temperature and humidity sensor
  dht.begin();

  // Start serial
  Serial.begin(9600);
}

void loop() {
  // Monitor serial communication
  while(Serial.available())
  {
    message = Serial.readString();
    messageReady = true;
  }

  // Only process message if there's one
  if (messageReady)
  {
    // Only parse JSON formatted message
    DynamicJsonDocument doc(1024);
    
    // Attempt to deserialize the message
    DeserializationError error = deserializeJson(doc, message);

    if (error)
    {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(error.c_str());
      messageReady = false;
      return;
    }
    if (doc["type"] == "request")
    {
      doc["type"] = "response";
      doc["light_intensity"] = lightMonitor(analogRead(lightSensor));
      doc["temperature"] = tempMonitor();
      doc["humidity"] = humidityMonitor();
      doc["soil_moisture"] = soilMonitor(analogRead(soilSensor));
      serializeJson(doc, Serial);
    }
    messageReady = false;
  }
}

int lightMonitor(int value)
{
  // Calculate light intensity percentage
  return ((value + lightMin) / (lightMax - lightMin)) * 100;
}

int tempMonitor()
{
  return dht.readTemperature();
}

int humidityMonitor()
{
  return dht.readHumidity();
}

int soilMonitor(float value)
{
  // Calculate soil moisture percentage
  return ((soilDry - value) / (soilDry - soilWet)) * 100;
}
