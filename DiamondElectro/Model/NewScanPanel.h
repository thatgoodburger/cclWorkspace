//
//  NewScanPanel.h
//  DiamondElectro
//
//  Created by Aaron Augsburger on 9/24/13.
//  Copyright (c) 2013 fraunhofer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewScanPanel : NSPanel

- (IBAction)InitialPNSelect:(id)sender;

- (IBAction)SaveSettings:(id)sender;
- (IBAction)ResetSettings:(id)sender;

@property (strong) IBOutlet NSSegmentedControl *InitialPNSlideValue;

@property (strong) IBOutlet NSTextField *initialETextField;
@property (strong) IBOutlet NSTextField *highETextField;
@property (strong) IBOutlet NSTextField *lowETextValue;

@end
