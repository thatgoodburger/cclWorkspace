//
//  DeviceSettingsPanel.m
//  DiamondElectro
//
//  Created by Aaron Augsburger on 9/26/13.
//  Copyright (c) 2013 fraunhofer. All rights reserved.
//

#import "DeviceSettingsPanel.h"

@implementation DeviceSettingsPanel

extern NSMutableDictionary *data;

@synthesize deviceListBox, baudTextField, connectedPort;	// The drop down menu


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
}

// Save the settings in global data
- (IBAction)doneButtonPress:(id)sender
{
	data[@"baud"] = baudTextField.stringValue;
	data[@"port"] = connectedPort.stringValue;
}

// Handler for when changing port field
- (IBAction)dropButtonPress:(id)sender
{
	[connectedPort setStringValue:[deviceListBox titleOfSelectedItem]];
}

@end
