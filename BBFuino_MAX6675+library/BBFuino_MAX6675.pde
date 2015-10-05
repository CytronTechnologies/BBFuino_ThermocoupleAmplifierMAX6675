#include <max6675.h>
#include <LiquidCrystal.h>
#include <Wire.h>

int CS = 10;
int SO = 12;
int SCK = 13;
int LED_G = A3;
int LED_R = A4;
int buzzer = A5;

MAX6675 thermocouple(SCK, CS, SO);
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

// make a cute degree symbol
uint8_t degree[8]  = {140,146,146,140,128,128,128,128};

void setup() {
  lcd.begin(16, 2);
  lcd.createChar(0, degree);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_R, OUTPUT);
  pinMode(buzzer, OUTPUT);
  // wait for MAX chip to stabilize
  delay(500);
}

void loop() {
  // basic readout test, just print the current temp
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp:");
  
  // go to line #1
  if(thermocouple.readCelsius() < 0)
  {
    lcd.print("Cold!!!");
    lcd.setCursor(0,1);
    celcius(thermocouple.readCelsius());  
    digitalWrite(LED_R, HIGH);   
    digitalWrite(LED_G, LOW);
    digitalWrite(buzzer, HIGH);
    delay(50);
  }
  
  else if(thermocouple.readCelsius() > 100)
  {
    lcd.print("Hot!!!");
    lcd.setCursor(0,1);
    celcius(thermocouple.readCelsius());  
    digitalWrite(LED_R, HIGH); 
    digitalWrite(LED_G, LOW);
    digitalWrite(buzzer, HIGH);
    delay(50);
  }
  else{
    lcd.setCursor(0,1);
    celcius(thermocouple.readCelsius());
    digitalWrite(buzzer, LOW);
    digitalWrite(LED_G, HIGH);    
    digitalWrite(LED_R, LOW);
  }

  delay(1000);
}

void symbol(void)
{
  #if ARDUINO >= 100
    lcd.write((byte)0);
  #else
    lcd.print(0, BYTE);
  #endif
}

void celcius(float a)
{
  lcd.print(a);
  symbol();
  lcd.print("C");
}

//  lcd.print(thermocouple.readFahrenheit());
//#if ARDUINO >= 100
//  lcd.write((byte)0);
//#else
//  lcd.print(0, BYTE);
//#endif
//  lcd.print('F');
//  
