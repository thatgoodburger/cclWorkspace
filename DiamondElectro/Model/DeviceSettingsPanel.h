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

@property (weak) IBOutlet NSPopUpButton *deviceListBox;

@property (weak) IBOutlet NSTextField *baudTextField;
@property (weak) IBOutlet NSTextField *connectedPort;

- (IBAction)scanPorts:(id)sender;
- (IBAction)doneButtonPress:(id)sender;
- (IBAction)dropButtonPress:(id)sender;

@end
