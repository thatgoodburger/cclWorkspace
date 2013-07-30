//
//  GSxPlot.m
//  GrapherApp
//
//  Created by Aaron Augsburger on 7/27/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import "GSxPlot.h"

const double e = 2.718;

@implementation GSxPlot

@synthesize scalar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
	if (self)
	  {
		scalar = 10000;
		pk1y = 200;
		pk2y = 200;
		pk2x = 325;
	  }
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	UIColor* pathColor = [UIColor blueColor];
	[pathColor setFill];
	
	// This path will be the actual curve of the graph
	UIBezierPath* graphPath = [UIBezierPath bezierPath];
	[graphPath moveToPoint:CGPointMake(0.0, rect.size.height - (pk1y + pk2y*pow(e,-(pk2x*pk2x))))];
		
	// Generator with max possible resolution (1pt/px)
	for (double i=1; i<rect.size.width; ++i)
	  {
		[graphPath addLineToPoint:CGPointMake(i, rect.size.height-(pk1y*pow(e,-(i*i/scalar)) +
																  (pk2y*pow(e,-((i-pk2x)*(i-pk2x)/scalar)))))];
	  }
	
	[graphPath stroke];
	[graphPath closePath];
	
	// Restore and save the initialization parameters.
	CGContextRestoreGState(context);
	CGContextSaveGState(context);
	
	
	
	[self setAxis];
}

- (void)setAxis
{
	
	
	// Draw the x-axis
	UIBezierPath* xAxis = [UIBezierPath bezierPath];
	xAxis.lineWidth = 3;
	[xAxis moveToPoint:CGPointMake(0.0, self.frame.size.height)];
	[xAxis addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
	[xAxis stroke];
	[xAxis closePath];
	
	// Draw the y-xis
	UIBezierPath* yAxis = [UIBezierPath bezierPath];
	yAxis.lineWidth = 3;
	[yAxis moveToPoint:CGPointMake(0.0, 0.0)];
	[yAxis addLineToPoint:CGPointMake(0.0, self.frame.size.height)];
	[yAxis stroke];
	[yAxis closePath];
}

@end
