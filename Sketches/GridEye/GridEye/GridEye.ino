#include <Wire.h>
#include <GridEye.h>

GridEye myeye;

void setup(void) {
  // Join the I2C bus
  Wire.begin();
  // Set the frame rate to 10
  myeye.setFramerate(10);

  // Initialize serial port
  Serial.begin(115200);
  while (!Serial) {
    ; // Wait for serial port connection
  }
}

// for storing pixel temperature data
int pixel[64];

void loop(void) {
  // Read the pixel temperature data at period of 100 ms
  delay(100);
  myeye. pixelOut(pixel);
  // Header transmission (for detecting delimiter position of data)
  Serial.write(0x55);
  Serial.write(0xaa);
  // pixel temperature data transmission (low order byte, high byte order)
  for (int i = 0; i < 64; i++) {
    Serial.write((pixel[i]      ) & 0xff);
    Serial.write((pixel[i]  >> 8) & 0xff);
  }
}
