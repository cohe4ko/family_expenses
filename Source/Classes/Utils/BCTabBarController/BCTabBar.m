//
//  BCTabBar.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "BCTabBar.h"
#import "BCTab.h"
#define kTabMargin 2.0

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;
@end

@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImage, delegate, isInvisible;

- (id)initWithFrame:(CGRect)aFrame {

	if (self = [super initWithFrame:aFrame]) {
		self.backgroundColor = [UIColor clearColor];
		self.backgroundImage = [[UIImage imageNamed:@"tabbar_background.png"] stretchableImageWithLeftCapWidth:160.0f topCapHeight:32.0f];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.frame.size.height)];
		[imageView setImage:self.backgroundImage];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
		[self addSubview:imageView];
		[imageView release];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

- (void)setTabs:(NSArray *)array {
	for (BCTab *tab in tabs) {
		[tab removeFromSuperview];
	}
	
	[tabs release];
	tabs = [array retain];
	
	for (BCTab *tab in tabs) {
		tab.userInteractionEnabled = YES;
		[tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
	}
	[self setNeedsLayout];
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		[selectedTab release];
		selectedTab = [aTab retain];
		selectedTab.selected = YES;
		
		for (BCTab *tab in tabs) {
			if (tab == aTab) 
				continue;
			tab.selected = NO;
		}
	}
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.origin.y = 0.00f;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	f.size.height = 49.00f;
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = f;
		f.origin.x += f.size.width;
		[self addSubview:tab];
	}
}

- (void)dealloc {
	[tabs release];
	[selectedTab release];
	[backgroundImage release];
	[super dealloc];
}


- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


@end
