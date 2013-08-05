//
//  GPxViewController.h
//  GrapherApp
//
//  Created by Aaron Augsburger on 7/27/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "GPxPlotViewController.h"

@interface GPxViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISlider *pk1yVal;
@property (strong, nonatomic) IBOutlet UISlider *pk2yVal;
@property (strong, nonatomic) IBOutlet UISlider *pk2xVal;
@property (strong, nonatomic) IBOutlet UISlider *scaleVal;

- (IBAction)pk1yChange:(id)sender;
- (IBAction)pk2yChange:(id)sender;
- (IBAction)pk2xChange:(id)sender;
- (IBAction)scaleChange:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *plotView;

@end
