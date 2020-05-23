#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>

ESP8266WebServer server;
char* ssid = "";
char* password = "";

void setup() {
   WiFi.begin(ssid, password);
   Serial.begin(9600);
   while(WiFi.status() != WL_CONNECTED)
   {
      Serial.print(".");
      delay(500);
   }
   Serial.println("");
   Serial.print("IP address: ");
   Serial.println(WiFi.localIP());

   server.on("/", handleIndex);
   server.begin();
}

void loop() {
  server.handleClient();
}

void handleIndex()
{
  // Send a JSON-formatted request with key "type" and value "request"
  // then parse the JSON-formatted response with keys "gas" and "distance"
  DynamicJsonDocument doc(1024);

  // Stats
  int lightIntensity = 0;
  int temperature = 0;
  int humidity = 0;
  int soilMoisture = 0;

  // Send the request
  doc["type"] = "request";
  serializeJson(doc, Serial);

  // Read the response
  boolean messageReady = false;
  String message = "";

  while (messageReady == false)
  {
    if (Serial.available())
    {
      message = Serial.readString();
      messageReady = true;  
    }
  }

  // Server the data as json
  server.send(200, "application/json", message);
}
