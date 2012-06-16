//
//  AMViewPie.m
//  Expenses
//
//  Created by Vinogradov Sergey on 17.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMViewPie.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@interface AMViewPie (Private)
- (void)make;
@end

@implementation AMViewPie

@synthesize color;

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	[self make];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self make];
    }
    return self;
}

- (void)setFrame:(CGRect)theFrame {
	[super setFrame:theFrame];
	
	[self make];
	
	[self setNeedsDisplay];
}

- (void)make {
	radius = 0.25f * (self.frame.size.width + self.frame.size.height);
	self.color = [UIColor whiteColor];
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
}

#pragma mark -
#pragma mark Setters

- (void)setValuesFromStart:(CGFloat)stVal toEnd:(CGFloat)endVal {
    startSegment = stVal;
    endSegment = endVal;
    
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)theColor {
    color = [theColor retain];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Draw

- (void)drawRect:(CGRect)rect {
	
	CGRect parentViewBounds = self.bounds;
	CGFloat x = CGRectGetWidth(parentViewBounds)/2;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
	// define stroke color
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    
	// define line width
	CGContextSetLineWidth(ctx, 4.0);
    
    CGContextSetFillColor(ctx, CGColorGetComponents( [self.color CGColor]));
    CGContextMoveToPoint(ctx, x, y);     
	CGContextAddArc(ctx, x, y, radius,  radians(startSegment-90), radians(startSegment+endSegment-90), 0);
    CGContextClosePath(ctx); 
    CGContextFillPath(ctx); 
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    [color release];
    [super dealloc];
}

@end
