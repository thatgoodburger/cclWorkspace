//
//  GSxPlot.h
//  GrapherApp
//
//  Created by Aaron Augsburger on 7/27/13.
//  Copyright (c) 2013 Aaron Augsburger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSxPlot : UIView
{
	double pk1y;
	double pk2y;
	double pk2x;
}

@property double scalar;

- (void)setAxis;

@end
