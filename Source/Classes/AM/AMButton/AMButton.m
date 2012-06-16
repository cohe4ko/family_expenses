//
//  AMButton.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMButton.h"
#import "UIColor-Expanded.h"

@interface AMButton (Private)
- (void)make;
@end

@implementation AMButton

@synthesize typeButton;

+ (id)withTypeButton:(AMButtonType)typeButton {
	AMButton *button = [[[AMButton alloc] init] autorelease];
	button.typeButton = typeButton;
	return button;
}

+ (id)buttonWithFrame:(CGRect)frame {
	return [[[AMButton alloc] initWithFrame:frame] autorelease];
}

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (void)awakeFromNib {
	[self make];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self make];
	}
	return self;
}

- (void)make {
	
	// Set type
	self.typeButton = AMButtonTypeDefault;
	
	// Set font and font color
	[[self titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
	[super setTitle:title forState:state];
	[self sizeToFit];
	float addW = (self.frame.size.width > 60) ? 14.00f : 14.00;
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + addW, self.frame.size.height)];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
	[super setImage:image forState:state];
	[self sizeToFit];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + 6.00f, self.frame.size.height)];
}

- (void)setTypeButton:(AMButtonType)theTypeButton {
	
	NSString *imageNormal = nil;
	NSString *imageHighlighted = nil;
	
	UIColor *titleColor;
	UIColor *titleColorHighlighted;
	UIColor *shadowColorNormal;
	UIColor *shadowColorHighlighted;
	UIColor *shadowColorSelected;
	
	CGSize shadowOffset;
	
	switch (theTypeButton) {
		case AMButtonTypeGreen:
			imageNormal = @"button_green_small.png";
			shadowColorNormal = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorHighlighted = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorSelected = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowOffset = CGSizeMake(0.00f, -1.00f);
			titleColor = [UIColor whiteColor];
			titleColorHighlighted = [UIColor whiteColor];
			break;
		case AMButtonTypeBlue:
			imageNormal = @"button_blue_small.png";
			shadowColorNormal = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorHighlighted = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorSelected = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowOffset = CGSizeMake(0.00f, -1.00f);
			titleColor = [UIColor whiteColor];
			titleColorHighlighted = [UIColor whiteColor];
			break;
		default:
			imageNormal = @"button.png";
			shadowColorNormal = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorHighlighted = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowColorSelected = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
			shadowOffset = CGSizeMake(0.00f, -1.00f);
			titleColor = [UIColor whiteColor];
			titleColorHighlighted = [UIColor whiteColor];
			break;
	}
	
	[self setTitleColor:titleColor forState:UIControlStateNormal];
	[self setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
	
	// Set background
	if (imageNormal)
		[self setBackgroundImage:[[UIImage imageNamed:imageNormal] stretchableImageWithLeftCapWidth:10.00f topCapHeight:0.00f] forState:UIControlStateNormal];
	
	if (imageHighlighted)
		[self setBackgroundImage:[[UIImage imageNamed:imageHighlighted] stretchableImageWithLeftCapWidth:10.00f topCapHeight:0.00f] forState:UIControlStateHighlighted];
	
	// Set shadow offset
	[[self titleLabel] setShadowOffset:shadowOffset];
	
	// Set shadow color
	[self setTitleShadowColor:shadowColorNormal forState:UIControlStateNormal];
	[self setTitleShadowColor:shadowColorHighlighted forState:UIControlStateHighlighted];
	[self setTitleShadowColor:shadowColorSelected forState:UIControlStateSelected];
}

@end
