void setup() 
{
  Serial.begin(9600);
}

void loop() 
{
  Serial.write("h");   delay(250);
  Serial.write("e");   delay(250);
  Serial.write("l");   delay(250);
  Serial.write("l");   delay(250);
  Serial.write("o");   delay(250);
  
  for(int i=0; i<5; ++i)
  {
    Serial.write("."); delay(250); 
  }
  
  Serial.write("?\n");  delay(500);
}
