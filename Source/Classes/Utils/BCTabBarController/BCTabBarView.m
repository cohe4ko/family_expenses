//
//  BCTabBarView.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "BCTabBarView.h"
#import "BCTabBar.h"
#import "Constants.h"

@implementation BCTabBarView
@synthesize tabBar, contentView;

#pragma mark -
#pragma mark Initializate

- (id)initWithFrame:(CGRect)frame {
	if (self == [super initWithFrame:frame]) {
	}
	return self;
}

#pragma mark -
#pragma mark Setters

- (void)setTabBar:(BCTabBar *)aTabBar {
	[tabBar removeFromSuperview];
	[tabBar release];
	tabBar = aTabBar;
	[self addSubview:tabBar];
}

- (void)setContentView:(UIView *)aContentView {
	[contentView removeFromSuperview];
	contentView = aContentView;
	contentView.frame = CGRectMake(0, 0.0f, self.bounds.size.width, self.bounds.size.height - self.tabBar.bounds.size.height);
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

	[self addSubview:contentView];
	[self sendSubviewToBack:contentView];
}

#pragma mark -
#pragma mark Other

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = contentView.frame;
    f.size.height = (self.tabBar.isInvisible) ? self.bounds.size.height : self.bounds.size.height - self.tabBar.bounds.size.height + 6.0f;
	contentView.frame = f;
    [contentView setNeedsLayout];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[super dealloc];
}

@end
