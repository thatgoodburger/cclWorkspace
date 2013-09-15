//
//  ArCAppDelegate.m
//  Arduino Controller
//
//  Created by Aaron Augsburger on 9/6/13.
//  Copyright (c) 2013 thatgoodburger. All rights reserved.
//

#import "ArCAppDelegate.h"

@implementation ArCAppDelegate

@synthesize deviceListBox, baudTextField, currentBaudRate, connectionStatus, connectedPort, readLabel;	// The drop down menu

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
}

// Scans for the available serial ports, lists them in portDisplay
- (IBAction)scanPorts:(id)sender
{
	io_object_t serialPort;
    io_iterator_t serialPortIterator;
	
	// Remove the current items listed
	[deviceListBox removeAllItems];
	
    // ask for all the serial ports
    IOServiceGetMatchingServices(kIOMasterPortDefault,IOServiceMatching(kIOSerialBSDServiceValue),&serialPortIterator);

	
    // loop through all the serial ports
    while ((serialPort = IOIteratorNext(serialPortIterator))) {
		
		// Add each serial device to the drop down list
		[deviceListBox addItemWithTitle: ((__bridge NSMutableString*)
										  IORegistryEntryCreateCFProperty(serialPort,
																		  CFSTR(kIOCalloutDeviceKey),
																		  kCFAllocatorDefault, 0))];
		
        IOObjectRelease(serialPort);
    }
	
	// Set the text to indicate that no items were found.
	if(deviceListBox.numberOfItems == 0)
		[deviceListBox addItemWithTitle:@"No Devices Found"];
	
    IOObjectRelease(serialPortIterator);
}

// Resets the value of the display to an empty string
- (IBAction)resetDisplay:(id)sender
{
	// Remove all the items in the list
	[deviceListBox removeAllItems];
	
	// Initialize back to the original text
	[deviceListBox addItemWithTitle:@"Please Scan Ports"];
}

// Opens the selected port
- (IBAction)openPort:(id)sender
{
	baudRate = [baudTextField intValue];
	
	// Display the rate & port
	[currentBaudRate setStringValue:[NSString stringWithFormat:@"Baud Rate: %lu", baudRate]];
	[connectedPort setStringValue:[NSString stringWithFormat:@"Port: %@",(NSString*)[deviceListBox titleOfSelectedItem]]];
	[connectionStatus setStringValue:[NSString stringWithFormat:@"Connection: Good"]];
	
	// c-string path to the serial-port
	const char *bsdPath = [[deviceListBox titleOfSelectedItem] cStringUsingEncoding:NSUTF8StringEncoding];
	struct termios options;
	
	// Open the port
	serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK);
	
	options = gOriginalTTYAttrs;
	cfmakeraw(&options);
}

// Closes the port that has been opened
- (IBAction)closePort:(id)sender
{
	[currentBaudRate setStringValue:@"Baud Rate: --"];
	[connectedPort setStringValue:@"Port: --"];
	[connectionStatus setStringValue:@"Connection: --"];
	
	close(serialFileDescriptor);
}

// Start reading serial data in
- (IBAction)startRead:(id)sender
{
	const int BUFFER_SIZE = 100;
	char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
	int numBytes=0; // number of bytes read during read
	NSString *text; // incoming text from the serial port
	
	// assign a high priority to this thread
	[NSThread setThreadPriority:1.0];
	
	// this will loop unitl the serial port closes
	while(TRUE) {
		// read() blocks until some data is available or the port is closed
		numBytes = (int)read(serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
		if(numBytes>0) {
			// create an NSString from the incoming bytes (the bytes aren't null terminated)
			text = [NSString stringWithCString:byte_buffer length:numBytes];
			[readLabel setStringValue:text];
			
		} else {
			break; // Stop the thread if there is an error
		}
	}
	
	// make sure the serial port is closed
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
}

// Stop the serial stream
- (IBAction)stopRead:(id)sender
{

}

@end
