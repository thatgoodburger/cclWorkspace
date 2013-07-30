//
//  NewScanViewController.m
//  VSx2
//
//  Created by Aaron Augsburger on 7/27/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import "NewScanViewController.h"

@interface NewScanViewController ()

@end

@implementation NewScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
	  
    }
    return self;
}

@synthesize ble;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	dpCounter = 0;
	dataPoints = [[NSMutableArray alloc] initWithCapacity:1000];
	
    ble = [[BLE alloc] init];
    [ble controlSetup:1];
    ble.delegate = self;
}

- (void)bleDidUpdateRSSI:(NSNumber *)rssi
{
	rssiLabel.text = rssi.stringValue;
}

- (void)bleDidConnect
{
	NSLog(@"BLE device did connect.");
}

- (void)bleDidDisconnect
{
	NSLog(@"BLE device did disconnect.");
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{	
	for (int i=0; i<length; i+=3)
	  {
		UInt16 Value = data[i+2] | data[i+1] << 8;
		
		if(dpCounter++ < 1000)
		  {
			[dataPoints addObject:[NSNumber numberWithUnsignedShort:Value]];
			NSLog(@"%i",dpCounter);
		  }
		
		if (data[i] == 0x00)
			sensorOneLevelBar.progress = ((float)Value/1000.0);
		
		else if (data[i] == 0x0F)
			sensorTwoLevelBar.progress = ((float)Value/1000.0);
		
		else if (data[i] == 0xFF)
			sensorThreeLevelBar.progress = ((float)Value/1000.0);
	  }
}

- (IBAction)connectBLE:(id)sender
{
  {
    if (ble.activePeripheral)
        if(ble.activePeripheral.isConnected)
		  {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [bleConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
		  }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [bleConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
  }
}

-(void) connectionTimer:(NSTimer *)timer
{
    [bleConnect setEnabled:true];
	[bleConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
	if (ble.peripherals.count > 0)
		[ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    else
		[bleConnect setTitle:@"Connect" forState:UIControlStateNormal];
}

@end
