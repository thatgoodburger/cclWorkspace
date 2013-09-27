//
//  DeviceSettingsPanel.m
//  DiamondElectro
//
//  Created by Aaron Augsburger on 9/26/13.
//  Copyright (c) 2013 fraunhofer. All rights reserved.
//

#import "DeviceSettingsPanel.h"

@implementation DeviceSettingsPanel


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

// Opens the selected port
- (IBAction)openPort:(id)sender
{
	// open the serial port
	NSString *error = [self openSerialPort: [deviceListBox titleOfSelectedItem] baud:[baudTextField intValue]];
	
	if(error!=nil) {
		//		[self refreshSerialList:error];
		[self appendToIncomingText:error];
	} else {
		//		[self refreshSerialList:[deviceListBox titleOfSelectedItem]];
		[self performSelectorInBackground:@selector(incomingTextUpdateThread:) withObject:[NSThread currentThread]];
	}
}

// Closes the port that has been opened
- (IBAction)closePort:(id)sender
{
	[currentBaudRate setStringValue:@"Baud Rate: --"];
	[connectedPort setStringValue:@"Port: --"];
	[connectionStatus setStringValue:@"Connection: --"];
	
	close(serialFileDescriptor);
}

- (IBAction)sendText:(id)sender
{
	
}

// send the string to arduino if the port is open
- (void) writeString: (NSString *) text
{
	if (serialFileDescriptor != -1)
		write(serialFileDescriptor, [text cStringUsingEncoding:NSUTF8StringEncoding], [text length]);
	else
		[self appendToIncomingText:@"\nPlease select serial port"];
}

// add the most recent text to the input field
- (void) appendToIncomingText: (id)text{
	// add text to the text area
	NSAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:text];
	NSTextStorage *textStorage = [serialOutput textStorage];
	[textStorage beginEditing];
	[textStorage appendAttributedString:attrString];
	[textStorage endEditing];
	
	// scroll to the bottom
	NSRange myRange;
	myRange.length = 1;
	myRange.location = [textStorage length];
	[serialOutput scrollRangeToVisible:myRange];
}

// reads input data to store as text
- (void) incomingTextUpdateThread: (NSThread *) parentThread {
	
	// mark that the thread is running
	readThreadRunning = TRUE;
	
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
			
			// this text can't be directly sent to the text area from this thread
			//  BUT, we can call a selctor on the main thread.
			[self performSelectorOnMainThread:@selector(appendToIncomingText:)
								   withObject:text
								waitUntilDone:YES];
		} else {
			break; // Stop the thread if there is an error
		}
	}
	
	// make sure the serial port is closed
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
	
	// mark that the thread has quit
	readThreadRunning = FALSE;
}

// open a specified serial port with error checking
- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate {
	int success;
	
	// close the port if it is already open
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
		
		// wait for the reading thread to die
		while(readThreadRunning);
		
		// re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
		sleep(0.5);
	}
	
	// c-string path to serial-port file
	const char *bsdPath = [serialPortFile cStringUsingEncoding:NSUTF8StringEncoding];
	
	// Hold the original termios attributes we are setting
	struct termios options;
	
	// receive latency ( in microseconds )
	unsigned long mics = 3;
	
	// error message string
	NSMutableString *errorMessage = nil;
	
	// open the port
	//     O_NONBLOCK causes the port to open without any delay (we'll block with another call)
	serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
	
	if (serialFileDescriptor == -1) {
		// check if the port opened correctly
		errorMessage = (NSMutableString*)@"Error: couldn't open serial port";
	} else {
		// TIOCEXCL causes blocking of non-root processes on this serial-port
		success = ioctl(serialFileDescriptor, TIOCEXCL);
		if ( success == -1) {
			errorMessage = (NSMutableString*)@"Error: couldn't obtain lock on serial port";
		} else {
			success = fcntl(serialFileDescriptor, F_SETFL, 0);
			if ( success == -1) {
				// clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
				errorMessage = (NSMutableString*)@"Error: couldn't obtain lock on serial port";
			} else {
				// Get the current options and save them so we can restore the default settings later.
				success = tcgetattr(serialFileDescriptor, &gOriginalTTYAttrs);
				if ( success == -1) {
					errorMessage = (NSMutableString*)@"Error: couldn't get serial attributes";
				} else {
					// copy the old termios settings into the current
					//   you want to do this so that you get all the control characters assigned
					options = gOriginalTTYAttrs;
					
					/*
					 cfmakeraw(&options) is equivilent to:
					 options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
					 options->c_oflag &= ~OPOST;
					 options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
					 options->c_cflag &= ~(CSIZE | PARENB);
					 options->c_cflag |= CS8;
					 */
					cfmakeraw(&options);
					
					// set tty attributes (raw-mode in this case)
					success = tcsetattr(serialFileDescriptor, TCSANOW, &options);
					if ( success == -1) {
						errorMessage = (NSMutableString*)@"Error: coudln't set serial attributes";
					} else {
						// Set baud rate (any arbitrary baud rate can be set this way)
						success = ioctl(serialFileDescriptor, IOSSIOSPEED, &baudRate);
						if ( success == -1) {
							errorMessage = (NSMutableString*)@"Error: Baud Rate out of bounds";
						} else {
							// Set the receive latency (a.k.a. don't wait to buffer data)
							success = ioctl(serialFileDescriptor, IOSSDATALAT, &mics);
							if ( success == -1) {
								errorMessage = (NSMutableString*)@"Error: coudln't set serial latency";
							}
						}
					}
				}
			}
		}
	}
	
	// make sure the port is closed if a problem happens
	if ((serialFileDescriptor != -1) && (errorMessage != nil)) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
	
	return errorMessage;
}

@end
