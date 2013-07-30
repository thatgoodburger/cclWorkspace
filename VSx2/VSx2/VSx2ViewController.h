//
//  VSx2ViewController.h
//  VSx2
//
//  Created by Aaron Augsburger on 7/26/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSx2ViewController : UIViewController
{
	IBOutlet UIButton *newScan;
	IBOutlet UIButton *loadScan;
	IBOutlet UIButton *options;
	IBOutlet UIButton *about;
	IBOutlet UIButton *userMode;
	
	IBOutlet UILabel *modeLabel;
}

- (IBAction)runNewScan:(id)sender;
- (IBAction)doLoadScan:(id)sender;
- (IBAction)openOptionsView:(id)sender;
- (IBAction)openAboutView:(id)sender;
- (IBAction)changeUserMode:(id)sender;

@end
