 #include <ble.h>
 #include <SPI.h>
 #include <BleFirmata.h>

 #define LIGHT_PIN_ONE    A0
 #define LIGHT_PIN_TWO    A1
 #define LIGHT_PIN_THREE  A2
  
 // the value for the light sensor 
 uint16_t lv1 = 0;
 uint16_t lv2 = 0;
 uint16_t lv3 = 0;
 
 void setup()
 { 
   SPI.setDataMode(SPI_MODE0);
   SPI.setBitOrder(LSBFIRST);
   SPI.setClockDivider(SPI_CLOCK_DIV16);
   SPI.begin(); 

   ble_begin();
 } 

 void loop()
 { 
   lv1 = analogRead(LIGHT_PIN_ONE);                  ble_write(lv1);
   lv2 = analogRead(LIGHT_PIN_TWO);    delay(25);    ble_write(lv2);
   lv3 = analogRead(LIGHT_PIN_THREE);  delay(25);    ble_write(lv3);
   
   //write values to the BLE stream from sensors
   ble_write(0x00);
   ble_write(lv1 >> 8);  ble_write(lv1);
   
   ble_write(0x0F);
   ble_write(lv2 >> 8);  ble_write(lv2);
  
   ble_write(0xFF);
   ble_write(lv3 >> 8);  ble_write(lv3);

 
   ble_do_events();
}

