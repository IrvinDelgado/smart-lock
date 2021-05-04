
#include <Keypad.h>
#include <Servo.h>
#include "U8glib.h"

#define SERVO_ON

#define ACCESS_GRANTED    97
#define ACCESS_DENIED     98
#define OPEN_LOCK         99
#define CLOSE_LOCK        100
#define SET_PASSWD        120

#define MIN               1000 // Position min 
#define MAX               2000 // Position max

//===================Define OLED Display Params=====================

U8GLIB_SH1106_128X64 u8g(U8G_I2C_OPT_NONE); // I2C / TWI 
 
const int WIDTH=128;
const int HEIGHT=64;
const int LENGTH=WIDTH;

//===================================================================

//===================Define Keypad  Params===========================
const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns

char keys[ROWS][COLS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};

// connect the pins from right to left to pin 2, 3, 4, 5, 6, 7, 8, 9
byte rowPins[ROWS] = {5,4,3,2}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {9,8,7,6}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

//===================================================================


Servo myservo;

int value_angle;
int toggle = 0;

char password[4] = {'3', '9', '5', '3'};
char keyList[4] = {};
uint8_t index = 0;

bool newData = false;
const uint8_t numChars = 32;
char receivedChars[numChars];

int motion_status;
const int buzzer = 10;
const int ledr = 11;
const int ir_sensor = 12;
const int ledy = 14;
bool ir_triggered = false;

void setup(){
  Serial.begin(9600);

  #ifdef SERVO_ON
    myservo.attach(13, MIN, MAX);
    pinMode(buzzer, OUTPUT);
  #endif
  
  u8g.setFont(u8g_font_unifont);
  u8g.setColorIndex(1); // Instructs the display to draw with a pixel on.
  u8g.firstPage(); 
  do {
      u8g.drawStr( 0, 20, "Enter Pass Code:");
  } while( u8g.nextPage() );
}
  
void loop(){
  getKey();
  getSerialData();
//  showNewData();
    
}

void getKey() {
  char key = keypad.getKey();
  
  if (key){
    
    if (index < 4){
      keyList[index] = key;
      updateDisplay();
      index++;
    }
    else {

      if(checkPassword()) {
        accessGranted();
      }
      else {
        accessDenied();
      }
      index = 0;
      delay(5000);
      clearDisplay();
    }
  } 
}

void getSerialData() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;
 
    while (Serial.available() > 0 && newData == false) {
        rc = Serial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
                parseIncomingData();
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

void readMotion() {
  motion_status = digitalRead(ir_sensor);
  if (motion_status == 0) {
    digitalWrite(ledr, LOW);
    ir_triggered = false;
  }
  else {
    digitalWrite(ledr, HIGH);
    if (!ir_triggered) {
      Serial.print(1);
      ir_triggered = true;
    }
  }
}


void showNewData() {
  if (newData ==true) {
    Serial.println(receivedChars);
    newData = false;
  }
}

void parseIncomingData() {
    if ((uint8_t)receivedChars[0] == ACCESS_GRANTED) {
      Serial.println("Granted");
      digitalWrite(ledr, HIGH );
      if (toggle == 0) {
        tone(buzzer, 500);
        toggle = 1;
        myservo.write(0);
        openLock();
        delay(2000);
        clearDisplay();
        Serial.println(toggle);
      }
      else {
        tone(buzzer, 1000);
        toggle = 0;
        myservo.write(180);
        closeLock();
        delay(2000);
        clearDisplay();
        Serial.println(toggle);
      }
      noTone(buzzer);
      digitalWrite(ledr, LOW);
    }
    else if ((uint8_t)receivedChars[0] == ACCESS_DENIED) {
      Serial.println("Denied");
      accessDenied();
      delay(2000);
      clearDisplay();
    }
    else if ((uint8_t)receivedChars[0] == OPEN_LOCK) {
        if (toggle == 0) {
        tone(buzzer, 500);
        toggle = 1;
        myservo.write(0);
        openLock();
        delay(2000);
        clearDisplay();
        Serial.println(toggle);
      }
    }
    else if ((uint8_t)receivedChars[0] == CLOSE_LOCK) {
        if (toggle == 1) {
          tone(buzzer, 1000);
          toggle = 0;
          myservo.write(180);
          closeLock();
          delay(2000);
          clearDisplay();
          Serial.println(toggle);
      }
    }
    else if ((uint8_t)receivedChars[0] == SET_PASSWD) {
        for (int i = 0; i < 4; i++) {
          password[i] = receivedChars[i+1];
          Serial.println(password[i]);
        }
    }
}

void updateDisplay() {

  String code = "";

  for(uint8_t i = 0; i <= index; i++){
    code += keyList[i];
  }

  u8g.firstPage(); 
    do{
      u8g.drawStr( 0, 20, "Enter Pass Code:");
      u8g.setPrintPos(50, 40);
      u8g.print(code);
    } while( u8g.nextPage() );
    
}

void clearDisplay() {
  u8g.firstPage(); 
  do {
    u8g.drawStr( 0, 20, "Enter Pass Code:");
  } while( u8g.nextPage() );
}

void getPosition() {
  Serial.println("GetPosition");
}

void setPosition(char pos) {
  Serial.println("SetPosition");
  if(pos == 0x00) {
    closeLock();
    delay(5000);
    clearDisplay();
  }
  else if (pos == 0x01) {
    openLock();
    delay(5000);
    clearDisplay();
  }
}

void accessGranted() {
  Serial.println("Granted");
  digitalWrite(ledr, HIGH );
  if (toggle == 0) {
    tone(buzzer, 500);
    toggle = 1;
    myservo.write(0);
    openLock();
    delay(2000);
    clearDisplay();
    Serial.println(toggle);
  }
  else {
    tone(buzzer, 1000);
    toggle = 0;
    myservo.write(180);
    closeLock();
    delay(2000);
    clearDisplay();
    Serial.println(toggle);
  }
  noTone(buzzer);
  digitalWrite(ledr, LOW);
  
  u8g.firstPage(); 
  do {
    u8g.drawStr( 0, 20, "Access Granted");
  } while( u8g.nextPage() );
}

void accessDenied() {
  u8g.firstPage(); 
  do {
    u8g.drawStr( 0, 20, "Access Denied");
  } while( u8g.nextPage() );

  value_angle = myservo.read();
}

void openLock() {
  u8g.firstPage(); 
  do {
    u8g.drawStr( 0, 20, "Opening Lock");
  } while( u8g.nextPage() );
}

void closeLock() {
  u8g.firstPage(); 
  do {
    u8g.drawStr( 0, 20, "Closing Lock");
  } while( u8g.nextPage() );
}

bool checkPassword() {
  for(uint8_t i = 0; i < 4; i++){
    if (keyList[i] != password[i]) {
      return false;
    }
  }
  return true;
}
