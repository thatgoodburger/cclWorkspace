//
//  NewScanViewController.h
//  VSx2
//
//  Created by Aaron Augsburger on 7/27/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface NewScanViewController : UIViewController <BLEDelegate>
{
	IBOutlet UILabel *rssiLabel;
	
	IBOutlet UIProgressView *sensorOneLevelBar;
	IBOutlet UIProgressView *sensorTwoLevelBar;
	IBOutlet UIProgressView *sensorThreeLevelBar;
	
	IBOutlet UIButton *bleConnect;
}

- (IBAction)connectBLE:(id)sender;

@property (strong, nonatomic) BLE *ble;

@end
