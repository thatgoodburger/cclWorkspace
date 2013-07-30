//
//  ViewController.h
//  BLE Com
//
//  Created by Aaron Augsburger on 7/21/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ViewController : UIViewController <BLEDelegate>
{
	IBOutlet UILabel *rssiLabel;
	IBOutlet UILabel *redLabel;
	
	IBOutlet UIProgressView *sensorOneLevelBar;
	IBOutlet UIProgressView *sensorTwoLevelBar;
	IBOutlet UIProgressView *sensorThreeLevelBar;
	
	IBOutlet UIButton *bleConnect;
}

- (IBAction)connectBLE:(id)sender;

@property (nonatomic, strong) BLE *ble;

@end
