//
//  LoadingView.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "LoadingView.h"
#import "Constants.h"

#define LOADING_VIEW_WIDTH		150.00f
#define LOADING_VIEW_HEIGHT		80.00f
#define LOADING_INDICATOR_SIZE	37.00f
#define LOADING_FONT_SIZE		17

@implementation LoadingView

@synthesize message;

- (id)initWithFrame:(CGRect)frame {
	message = NSLocalizedString(@"loading", @"Loading");
	
	if (self = [super initWithFrame:frame]) {
		
		self.userInteractionEnabled = FALSE;
		self.backgroundColor = [UIColor clearColor];
		self.hidden = TRUE;
		
		frame.origin.y -= 25.00f;
		
		view = [[UIView alloc] initWithFrame:frame];
		view.backgroundColor = [UIColor clearColor];
		view.userInteractionEnabled = FALSE;
		
		// Create background
		viewBg = [[UIView alloc] initWithFrame:CGRectMake(0.00f, 0.00f, LOADING_VIEW_WIDTH, LOADING_VIEW_HEIGHT)];
		viewBg.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 30.00f);
		viewBg.backgroundColor = [UIColor blackColor];
		viewBg.layer.masksToBounds = YES;
		viewBg.layer.cornerRadius = 10.0;
		viewBg.alpha = 0.8;
		[view addSubview:viewBg];
		
		// Create Activity Indicator
		activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.00f, 0.00f, LOADING_INDICATOR_SIZE, LOADING_INDICATOR_SIZE)];
		activity.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10.00f + 30.00f);
		activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;  
		[activity startAnimating];
		[view addSubview:activity];
		
		// Create Label
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.00f, 0.00f, LOADING_VIEW_WIDTH - 20.00f, 20.00f)];
		label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 22.00f + 30.00f);
		label.text = message;
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"Arial" size:LOADING_FONT_SIZE];
		label.textAlignment = UITextAlignmentCenter;
		[view addSubview:label];
		
		[self addSubview:view];
	}
	return self;
}

- (void)setMessage:(NSString *)_message {
	if (message != _message) {
		message = [_message retain];
		[label setText:message];
		[label sizeToFit];
		[self redraw:[UIApplication sharedApplication].statusBarOrientation];
	}
}

- (void)changeRect {
	[self redraw:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)redraw:(UIInterfaceOrientation)interfaceOrientation {
	BOOL portrait = !UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	if (IS_IPAD)
		self.frame = CGRectMake(0.00f, 0.00f, (portrait) ? 768.00f : 1004.00f, (portrait) ? 1004.00f : 768.00f);
	else
		self.frame = CGRectMake(0.00f, 0.00f, (portrait) ? 320.00f : 460.00f, (portrait) ? 460.00f : 320.00f);
	
	view.frame = self.frame;
	
	activity.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10.00f);
	
	[label setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 22.00f)];
	
	float bgWidth = (label.frame.size.width + 20.00f < LOADING_VIEW_WIDTH) ? LOADING_VIEW_WIDTH : label.frame.size.width + 20.00f;
	
	[viewBg setFrame:CGRectMake(0.00f, 0.00f, bgWidth, viewBg.frame.size.height)];
	[viewBg setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)];
}

@end
