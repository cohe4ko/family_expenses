//
//  RIPageControl.m
//  CostApp
//
//  Created by Ruslan on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RIPageControl.h"
#import <QuartzCore/QuartzCore.h>

#define kRoundRadius 2.5
#define kRoundOffset 5

@implementation RIPageControl
@synthesize numberOfPages;
@synthesize currentPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfPages = 0;
        self.currentPage = 0;
        color1 = [[UIColor alloc] initWithCGColor:[UIColor lightGrayColor].CGColor];
        color2 = [[UIColor alloc] initWithCGColor:[UIColor blackColor].CGColor];
        // Initialization code
    }
    return self;
}

-(void)changeColors:(UIColor*)newColor1 forSec:(UIColor*)newColor2{
    if (newColor1 && newColor2) {
        if (color1) {
            [color1 release];
        }
        
        if (color2) {
            [color2 release];
        }
        
        color1 = [[UIColor alloc] initWithCGColor:newColor1.CGColor];
        color2 = [[UIColor alloc] initWithCGColor:newColor2.CGColor];
        [self setNeedsDisplay];
    }
}

-(void)setCurrentPage:(NSInteger)cP{
    currentPage = cP;
    [self setNeedsDisplay];
}

-(void)setNumberOfPages:(NSInteger)nP{
    numberOfPages = nP;
    if (numberOfPages<2) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color1.CGColor);
    NSInteger x = self.frame.size.width/2.0-(kRoundOffset*(numberOfPages+1)+2*kRoundRadius*numberOfPages)/2.0;
    for (int i=0; i<self.numberOfPages; i++) {
        if (i != self.currentPage) {
            CGContextFillEllipseInRect(context, CGRectMake(x+kRoundOffset*(i+1)+2*kRoundRadius*i,
                                                           self.frame.size.height/2.0-kRoundRadius,
                                                           2*kRoundRadius,
                                                           2*kRoundRadius));
        }else{
            CGContextSetFillColorWithColor(context, color2.CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(x+kRoundOffset*(i+1)+2*kRoundRadius*i,
                                                           self.frame.size.height/2.0-kRoundRadius,
                                                           2*kRoundRadius,
                                                           2*kRoundRadius));
            CGContextSetFillColorWithColor(context, color1.CGColor);
        }
    }
}

-(void)dealloc{
    [super dealloc];
    
    if (color1) {
        [color1 release];
    }
    
    if (color2) {
        [color2 release];
    }
}

@end
