//
//  MainViewWindow.h
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

@interface MainViewWindow : NSWindow
{
	int serialFileDescriptor;
	bool readThreadRunning;
	struct termios gOriginalTTYAttrs;
	NSTextStorage *storage;
}

- (IBAction)openPort:(id)sender;

@property (strong) IBOutlet NSTextField *portTextField;

@end
