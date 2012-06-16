//
//  AMButtonBack.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMButtonBack.h"

@implementation AMButtonBack

+ (id)buttonWithFrame:(CGRect)frame {
	return [[[AMButtonBack alloc] initWithFrame:frame] autorelease];
}

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		// Set background
		[self setBackgroundImage:[[UIImage imageNamed:@"button_back.png"] stretchableImageWithLeftCapWidth:17.00f topCapHeight:0.00f] forState:UIControlStateNormal];
		//[self setBackgroundImage:[[UIImage imageNamed:@"button_back-selected.png"] stretchableImageWithLeftCapWidth:17.00f topCapHeight:0.00f] forState:UIControlStateHighlighted];
		
		// Set font and font color
		[[self titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		// Set shadow color
		[self setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateHighlighted];
		
		// Set shadow rect
		[[self titleLabel] setShadowOffset:CGSizeMake(0.00f, -1.00f)];
		
		// Set insets
		[super setTitleEdgeInsets:UIEdgeInsetsMake(0.00f, 0.00f, 0.00f, 0.00f)];
		[super setContentEdgeInsets:UIEdgeInsetsMake(0.00f, 6.00f, 0.00f, 0.00f)];
		
		// Set truncate
		[[super titleLabel] setLineBreakMode:UILineBreakModeTailTruncation];
		
		// Resize
		[self sizeToFit];
	}
	return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
	[super setImage:image forState:state];
	[self sizeToFit];
	float width = self.frame.size.width > 60 ? 60 : self.frame.size.width;
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width + 0.00f, self.frame.size.height)];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
	[super setTitle:title forState:state];
	[self sizeToFit];
	float width = self.frame.size.width > 60 ? 60 : self.frame.size.width;
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width + 10.00f, self.frame.size.height)];
}

@end
