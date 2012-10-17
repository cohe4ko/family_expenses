//
//  TitleOffsetButton.m
//  Expenses
//
//  Created by Ruslan on 15.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TitleOffsetButton.h"

@implementation TitleOffsetButton
@synthesize titleOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitleOffset:(CGFloat)_titleOffset{
    titleOffset = _titleOffset;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.frame = CGRectMake(titleOffset, self.titleLabel.frame.origin.y, self.frame.size.width-2*titleOffset, self.titleLabel.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
