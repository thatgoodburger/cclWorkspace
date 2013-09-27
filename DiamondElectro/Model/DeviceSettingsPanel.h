//
//  DeviceSettingsPanel.h
//  DiamondElectro
//
//  Created by Aaron Augsburger on 9/26/13.
//  Copyright (c) 2013 fraunhofer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>

@interface DeviceSettingsPanel : NSPanel
{
	int serialFileDescriptor;
	bool readThreadRunning;
	struct termios gOriginalTTYAttrs;
	NSTextStorage *storage;
}

@property (weak) IBOutlet NSPopUpButton *deviceListBox;

@property (weak) IBOutlet NSTextField *baudTextField;
@property (weak) IBOutlet NSTextField *currentBaudRate;
@property (weak) IBOutlet NSTextField *connectionStatus;
@property (weak) IBOutlet NSTextField *connectedPort;
@property (weak) IBOutlet NSTextField *readLabel;

@property (unsafe_unretained) IBOutlet NSTextView *serialOutput;

@property (weak) IBOutlet NSButton *scanButton;
@property (weak) IBOutlet NSButton *openPortButton;
@property (weak) IBOutlet NSButton *closePortButton;
@property (weak) IBOutlet NSButton *sendTextButton;

- (IBAction)scanPorts:(id)sender;
- (IBAction)openPort:(id)sender;
- (IBAction)closePort:(id)sender;
- (IBAction)sendText:(id)sender;

- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate;
- (void) appendToIncomingText: (id)text;
- (void) incomingTextUpdateThread: (NSThread *) parentThread;

@end
