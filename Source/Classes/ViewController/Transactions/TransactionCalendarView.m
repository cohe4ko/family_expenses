//
//  TransactionCalendarView.m
//  Expenses
//
//  Created by MacBook iAPPLE on 09.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionCalendarView.h"

@implementation TransactionCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *roundedBound = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0];
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:203.0/255.0 green:157.0/255.0 blue:90.0/255.0 alpha:1.0].CGColor);
    [roundedBound setLineWidth:4.0];
    [roundedBound addClip];
    [roundedBound stroke];
}


@end
