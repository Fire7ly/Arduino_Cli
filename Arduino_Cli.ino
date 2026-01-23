#include "./src/echo.h"
#include <Arduino.h>

void setup() { Serial.begin(2400); }

void loop() {
  Serial.println("Hello, World!");
  echo();
  delay(1000);
}