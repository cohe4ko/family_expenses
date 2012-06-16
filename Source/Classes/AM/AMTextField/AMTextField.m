//
//  AMTextField.m
//  Expenses
//
//  Created by Vinogradov Sergey on 11.09.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMTextField.h"

@implementation AMTextField

@synthesize parentIdx, idx, object;

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	x = 10.0f;
	
	// Clear background
	self.backgroundColor = [UIColor clearColor];
	
	// Set border
	self.borderStyle = UITextBorderStyleNone;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, x, 10);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, x + 3.0f, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 20.0f, bounds.size.height), x, 10);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
	CGRect rect = [super clearButtonRectForBounds:bounds];
	rect.origin.x -= 3.0f;
	return rect;

}

#pragma mark -
#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)image {
	
	CGFloat oldHeight = self.frame.size.height;
	
	// Add background image
	UIImageView *imageBg = [[[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:10 topCapHeight:10]] autorelease];
	[self addSubview:imageBg];
	
	// Change rect
	CGRect r = imageBg.frame;
	r.size.width = self.frame.size.width;
	imageBg.frame = r;
	
	r = self.frame;
	r.size.height = imageBg.frame.size.height;
	r.origin.y -= (r.size.height - oldHeight) / 2;
	self.frame = r;
}

- (void)setPlaceholderColor:(UIColor *)color {
	[self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)setPromptText:(NSString *)aText {
	
	[[self viewWithTag:123] removeFromSuperview];
	
	CGSize titleSize = [aText sizeWithFont:self.font];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9.0f, 12.0f, titleSize.width , titleSize.height)];
	[label setTag:123];
	[label setText:aText];
	[label setFont:self.font];
	[label setTextColor:self.textColor];
	[label sizeToFit];
	[self addSubview:label];
	x = label.frame.origin.x + label.frame.size.width + 2.0f;
	[label release];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[object release];
	[super dealloc];
}

@end
