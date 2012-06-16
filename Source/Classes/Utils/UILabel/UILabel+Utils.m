//
//  UILabel+Utils.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (VerticalAlign)

- (void)alignTop {
	self.numberOfLines = 0;
	int width = self.frame.size.width;
	[self sizeToFit];
	CGSize maximumSize = CGSizeMake(width, self.frame.size.height);
	UIFont *labelFont = self.font;
	CGSize labelStringSize = [self.text sizeWithFont:labelFont constrainedToSize:maximumSize lineBreakMode:self.lineBreakMode];
	CGRect labelFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, labelStringSize.height);
	self.frame = labelFrame;
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
	
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
	int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++) {
        self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}

@end