//
//  BCTab.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "BCTab.h"
#import "UIColor-Expanded.h"
#import "UILabel+Utils.h"
#import "Constants.h"

@interface BCTab ()
@property (nonatomic, retain) UIImageView *background;
@end

@implementation BCTab
@synthesize background, isCenter, idx;

- (id)initWithIconImageName:(NSString *)theImageName andName:(NSString *)theName {
	if (self = [self initWithFrame:CGRectMake(0.00f, 7.00f, 0.00f, 49.00f)]) {
		name = [theName retain];
		imageName = [theImageName retain];
		
		self.adjustsImageWhenHighlighted = NO;
		self.backgroundColor = [UIColor clearColor];
		
		NSString *selectedName = [NSString stringWithFormat:@"%@-selected.%@", [imageName stringByDeletingPathExtension], [imageName pathExtension]];
		
		[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
		
		if (name && name.length) {
			
			label = [[UILabel alloc] initWithFrame:CGRectMake(0.00f, 40.00f, 0.00f, 11.0f)];
			[label setBackgroundColor:[UIColor clearColor]];
			
			// Set title
			[label setText:name];
			
			// Set title aligment
			[label setTextAlignment:UITextAlignmentCenter];
			
			// Set font
			[label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]];
			
			// Set color
			[label setTextColor:[UIColor colorWithHexString:@"a8a8a8"]];
			
			// Set shadow color
			[label setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
			
			// Set shadow rect
			[label setShadowOffset:CGSizeMake(0.00f, 0.00f)];
			
			[self addSubview:label];
		}
	}
	return self;
}

- (void)setHighlighted:(BOOL)aBool {
	
}

- (void)drawRect:(CGRect)rect {
	CGRect r = label.frame;
	r.size.width = self.frame.size.width + 0.00f;
	r.origin.x = self.frame.size.width / 2 - r.size.width / 2;
	label.frame = r;
	[label alignTop];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	
	int add = ([[imageName stringByDeletingPathExtension] isEqualToString:@"tabbar_add"]) ? -6.0f : 4.0f;
	
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(
												floor((self.bounds.size.height / 2) - (self.imageView.image.size.height / 2) + add), 
												floor((self.bounds.size.width / 2) - (self.imageView.image.size.width / 2)), 
												floor((self.bounds.size.height / 2) - (self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) - (self.imageView.image.size.width / 2))
												);
	[super setImageEdgeInsets:imageInsets];
	
	[super layoutSubviews];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[imageName release], imageName = nil;
	[name release], name = nil;
	[label release], label = nil;
	[background release], background = nil;
	[super dealloc];
}

@end
