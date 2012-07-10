//
//  TransactionCalendarView.m
//  Expenses
//
//  Created by MacBook iAPPLE on 09.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionCalendarView.h"

@implementation TransactionCalendarView
@synthesize selected;

-(void)awakeFromNib{
    titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    detailLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setSelected:(BOOL)_selected{
    if (_selected != selected) {
        selected = _selected;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *roundedBound = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0];
    if (selected) {
             
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:203.0/255.0 green:157.0/255.0 blue:90.0/255.0 alpha:1.0].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:212.0/255.0 green:214.0/255.0 blue:216.0/255.0 alpha:1.0].CGColor);
        CGContextSetShadow(context, CGSizeMake(0, 2), 5);
        [roundedBound setLineWidth:6.0];
        [roundedBound addClip];
        [roundedBound fill];
        [roundedBound stroke];
        [roundedBound setLineWidth:1.0];
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:102.0/255.0 green:21.0/255.0 blue:22.0/255.0 alpha:1.0].CGColor);
        [roundedBound stroke];
    }else {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:102.0/255.0 green:21.0/255.0 blue:22.0/255.0 alpha:0.9].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:212.0/255.0 green:214.0/255.0 blue:216.0/255.0 alpha:1.0].CGColor);
        CGContextSetShadow(context, CGSizeMake(0, 2), 5);
        [roundedBound setLineWidth:4.0];
        [roundedBound addClip];
        [roundedBound fill];
        [roundedBound stroke];
    }
}

-(void)dealloc{
    [titleLabel release];
    [detailLabel release];
    [super dealloc];
}

@end
