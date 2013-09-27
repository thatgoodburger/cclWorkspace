String inputString = "";           // string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
int inByte = 0;                  // incoming serial byte


void setup() 
{
  // initialize serial:
  Serial.begin(9600);
  // reserve some bytes for the inputString:
  inputString.reserve(200);
  // broadcast a message:
  establishContact();
}

void loop() 
{
  // print the string when a newline arrives
  if (stringComplete) {
    
    if(!strcmp(inputString.c_str(), "Hello")){
      Serial.println("Don't look at me in the eyes."); 
    }
    
    Serial.println(inputString);
    // clear the string:
    inputString = "";
    stringComplete = false;
  }
}

// runs between loop runs, detects data via serial RX
void serialEvent() 
{
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // detect a newline to tell main about completion:
    if (inChar == '\n')
      stringComplete = true;
    else
      // add to the inputString:
      inputString += inChar;
  }
}

// initial means of contacting PC
void establishContact()
{
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");
    delay(300);
  }
}
