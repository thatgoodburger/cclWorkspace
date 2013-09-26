//
//  GraphView.m
//  ScatterMac
//
//  Created by Steven Uy on 9/6/13.
//  Copyright (c) 2013 Steven Uy. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



//float dataY[]; // = {7, 4, 9, 1, 2, 8, 11, 7, 5, 4, 8, 7, 9, 5}; //Y Coordinates
//float dataX[]; // = {0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5}; //X Coordinates

//Min and Max
float dataY_min, dataY_max, dataX_min, dataX_max;

//Range
float dataY_range;
float dataX_range;

// How many lines?
int howManyVertical = (kDefaultGraphWidth - kOffsetX) / kStepX;
int howManyHorizontal = (kGraphHeight - kOffsetY) / kStepY;

//data Ratio
int maxGraphHeight;
int maxGraphWidth;
int num_data_points = (int)((FinalE-InitE)/IncrE);
float Data_ratio_Y;
float Data_ratio_X;

//Arrays
NSMutableArray *dataY;
NSMutableArray *dataX;

+ (void)initialize {     
    //Arrays
    dataY = [[NSMutableArray alloc] init];
    dataX = [[NSMutableArray alloc] init];
    
    //Read Text File
    NSString* filePath = @"DPV"; //file path...
    NSString* fileRoot = [[NSBundle mainBundle]
                          pathForResource:filePath ofType:@"txt"];
    NSString* fileContents =
    [NSString stringWithContentsOfFile:fileRoot
                              encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int i;
    //Split up text into dataX and dataY
    for (i = 0; i < [allLinedStrings count]; i = i+3) {
        [dataX addObject:[NSNumber numberWithFloat: [allLinedStrings[i] floatValue]]];
        [dataY addObject:[NSNumber numberWithFloat: [allLinedStrings[i+1] floatValue]]];
    }
    // Max Min
    NSNumber* dataY_min = [dataY valueForKeyPath:@"@min.self"];
    NSNumber* dataY_max = [dataY valueForKeyPath:@"@max.self"];
    // Y
    dataY_range = [dataY_max floatValue] - [dataY_min floatValue];
    maxGraphHeight = howManyHorizontal * kStepY;
    Data_ratio_Y = maxGraphHeight / dataY_range * 4/5;
    // X
    dataX_min = InitE;
    dataX_max = FinalE;
    dataX_range = dataX_max - dataX_min;
    maxGraphWidth = howManyVertical * kStepX;
    Data_ratio_X = maxGraphWidth / dataX_range;
}


- (void)drawRect:(CGRect)rect
{
    [[NSColor darkGrayColor] set];
    NSRectFill([self bounds]);
    
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [[NSColor whiteColor] CGColor]);
    
    // Axis Lines
    CGContextMoveToPoint(context, kOffsetX, kOffsetY);
    CGContextAddLineToPoint(context, kOffsetX, kOffsetY + (howManyHorizontal) * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kOffsetY);
    CGContextAddLineToPoint(context, kOffsetX + howManyVertical * kStepX, kOffsetY);
    
    //Draw it!
    CGContextStrokePath(context);
    
    // Other Lines Format
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[NSColor whiteColor] CGColor]);
    //Dash
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);

     // Lines for Y
     for (int i = 1; i <= howManyVertical; i++)
     {
     CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphBottom + kOffsetY + (howManyHorizontal * kStepY) );
     CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom + kOffsetY);
     }
     
    // Lines for X
    for (int i = 1; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom + kOffsetY + i * kStepY);
        CGContextAddLineToPoint(context, kOffsetX +  howManyVertical * kStepX , kGraphBottom + kOffsetY + i * kStepY);
    }
    
    //Draw it!
    CGContextStrokePath(context);
    
    //Remove Line Dash Format
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    
    // X and Y Labels
    CGContextSelectFont(context, "Helvetica", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[NSColor yellowColor] CGColor]);
    NSString *Potential = @"Potential [V]";
    CGContextShowTextAtPoint(context, (kStepX * howManyVertical - kOffsetX) / 2, kOffsetY / 4, [Potential cStringUsingEncoding:NSUTF8StringEncoding], [Potential length]);
    NSString *Current = @"Current [A]";
    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0), M_PI / 2));    //Rotation
    CGContextShowTextAtPoint(context, kOffsetX *3/10, (kStepY * howManyHorizontal - kOffsetY) / 2, [Current cStringUsingEncoding:NSUTF8StringEncoding], [Current length]);
    
    //X Labels
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[NSColor yellowColor] CGColor]);
    for (int i = 0; i < howManyVertical; i++)
    {
        NSString *theText = [NSString stringWithFormat:@"%.02f",[dataX[(int)(i * num_data_points/howManyVertical)] floatValue] ] ;
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX - 5, kGraphBottom + kOffsetY * 5/8, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
    
    //Y Labels
    for (int i = 0; i < howManyHorizontal; i++)
    {
        NSString *theText = [NSString stringWithFormat:@"%.02e", i* dataY_range * 5/4 / howManyHorizontal];
        CGContextShowTextAtPoint(context, kOffsetX * 4/8, kOffsetY + i * kStepY, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
    
    //Points
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[NSColor yellowColor] CGColor]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, Data_ratio_Y * [dataY[0] floatValue]+ kOffsetY);
    
    for (int i = 1; i < num_data_points; i++)
    {
        CGContextAddLineToPoint(context, Data_ratio_X * ([dataX[i] floatValue]- InitE) + kOffsetX, Data_ratio_Y * [dataY[i] floatValue] + kOffsetY);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
}




@end
