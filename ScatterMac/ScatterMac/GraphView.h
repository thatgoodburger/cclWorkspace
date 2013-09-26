//
//  GraphView.h
//  ScatterMac
//
//  Created by Steven Uy on 9/6/13.
//  Copyright (c) 2013 Steven Uy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GraphView : NSView

//User Defined Parameters
#define InitE -1
#define FinalE +0.6
#define IncrE +0.002
#define Amplitude 0.05
#define PulseWidth 0.05
#define SamplingWidth 0.005
#define PulsePeriod 0.1
#define QuietTime 20
#define Sensitivity 1e-6

//Graph Parameters Logic
#define kGraphHeight 500
#define kDefaultGraphWidth 1000
#define kOffsetX 100
#define kStepX 40
#define kGraphBottom 0
#define kGraphTop 500
#define kStepY 40
#define kOffsetY 50
#define kCircleRadius 3

@end
