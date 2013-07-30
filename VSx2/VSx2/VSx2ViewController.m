//
//  VSx2ViewController.m
//  VSx2
//
//  Created by Aaron Augsburger on 7/26/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import "VSx2ViewController.h"

@interface VSx2ViewController ()
{

}


@end

@implementation VSx2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)runNewScan:(id)sender
{
	
}

- (IBAction)doLoadScan:(id)sender
{
	
}

- (IBAction)openOptionsView:(id)sender
{
	
}

- (IBAction)openAboutView:(id)sender
{
	
}

- (IBAction)changeUserMode:(id)sender
{
	if ([modeLabel.text isEqualToString:@"Consumer"] == YES)
		modeLabel.text = @"Scientific";
	else
		modeLabel.text = @"Consumer";
}

@end
