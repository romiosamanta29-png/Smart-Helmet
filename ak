#include <Servo.h>

Servo myServo;

const int SERVO_PIN = 9;    // PWM pin
const int MIN_ANGLE = 0;
const int MAX_ANGLE = 180;
const int STEP_DELAY = 15;  // ms between steps

void setup() {
  Serial.begin(9600);
  myServo.attach(SERVO_PIN);
  Serial.println("Servo Motor Check Started");
  Serial.println("Commands: F=Full sweep, C=Center, 0-180=Set angle");
}

void loop() {
  // Auto sweep on startup
  sweepServo();

  // Handle serial commands
  while (Serial.available()) {
    String input = Serial.readStringUntil('\n');
    input.trim();

    if (input == "F" || input == "f") {
      sweepServo();
    } else if (input == "C" || input == "c") {
      setAngle(90);
    } else {
      int angle = input.toInt();
      if (angle >= MIN_ANGLE && angle <= MAX_ANGLE) {
        setAngle(angle);
      } else {
        Serial.println("Invalid input. Use F, C, or 0-180.");
      }
    }
  }
}

// Sweep from 0 to 180 and back
void sweepServo() {
  Serial.println("Sweeping 0 → 180...");
  for (int angle = MIN_ANGLE; angle <= MAX_ANGLE; angle++) {
    myServo.write(angle);
    delay(STEP_DELAY);
  }

  Serial.println("Sweeping 180 → 0...");
  for (int angle = MAX_ANGLE; angle >= MIN_ANGLE; angle--) {
    myServo.write(angle);
    delay(STEP_DELAY);
  }

  setAngle(90); // Return to center
  Serial.println("Sweep complete. Centered at 90°");
}

// Move to a specific angle
void setAngle(int angle) {
  myServo.write(angle);
  Serial.print("Servo moved to: ");
  Serial.print(angle);
  Serial.println("°");
  delay(500);
}
