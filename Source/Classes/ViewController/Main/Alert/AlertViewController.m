//
//  AlertViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 08.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController (Private)
@end

@implementation AlertViewController

@synthesize target, selector;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	[super setTabbarShadowHide];
	
	CGRect r;
	
	r = viewTop.frame;
	r.origin.y = 0 - r.size.height;
	viewTop.frame = r;
	
	r = viewBottom.frame;
	r.origin.y = self.view.bounds.size.height;
	viewBottom.frame = r;
	
	viewOpacity.alpha = 0.0f;
	viewContent.hidden = YES;
	
	self.view.hidden = YES;
	
	// Set button
	[button setTypeButton:AMButtonTypeDefault];
	[button setTitle:NSLocalizedString(@"close", @"Close") forState:UIControlStateNormal];
	[button setCenter:CGPointMake(viewContent.frame.size.width / 2, button.center.y)];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionClose {
	[self hide];
}

#pragma mark -
#pragma mark Set

- (void)setTitle:(NSString *)theTitle {
	[labelTitle setText:theTitle];
}

- (void)setMessage:(NSString *)message {
	[labelMessage setText:message];
}

#pragma mark -
#pragma mark Show / hide

- (void)show {
	
	self.view.alpha = 1.0f;
	self.view.hidden = NO;
	
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseIn animations:^{
		CGRect r;
		
		float y = self.view.frame.size.height / 2;
		
		r = viewTop.frame;
		r.origin.y = y - r.size.height + 5.00f;
		viewTop.frame = r;
		
		r = viewBottom.frame;
		r.origin.y = y - 55.00f;
		viewBottom.frame = r;
		
		viewOpacity.alpha = 1.0f;
		
	} completion:^(BOOL finished) {
		[viewContent addSubview:labelTitle];
		[viewContent addSubview:button];
		
		CGRect r;
		
		r = button.frame;
		r.origin.y = viewContent.frame.size.height - r.size.height - 15.00f;
		button.frame = r;
		
		viewContent.hidden = NO;
	}];
}

- (void)hide {
	[UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationCurveEaseOut animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[viewTop addSubview:labelTitle];
		[viewBottom addSubview:button];
		
		CGRect r;
		
		r = viewTop.frame;
		r.origin.y = 0 - r.size.height;
		viewTop.frame = r;
		
		r = viewBottom.frame;
		r.origin.y = self.view.bounds.size.height;
		viewBottom.frame = r;
		
		r = button.frame;
		r.origin.y = viewBottom.frame.size.height - r.size.height - 15.00f;
		button.frame = r;
		
		viewOpacity.alpha = 0.00f;
		viewContent.hidden = YES;
		
		self.view.hidden = YES;
		
		if (target && selector) {
			if ([target respondsToSelector:selector])
				[target performSelector:selector];
		}
	}];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[target release];
    [super dealloc];
}

@end