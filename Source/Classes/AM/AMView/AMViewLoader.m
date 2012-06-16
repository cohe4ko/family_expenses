//
//  AMViewLoader.m
//  Expenses
//
//  Created by Vinogradov Sergey on 11.09.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMViewLoader.h"

#import "UILabel+Utils.h"

@interface AMViewLoader (Private)
- (void)makeLocale;
@end

@implementation AMViewLoader

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	[self setAlpha:0.0f];
	
	// Make locale
	[self makeLocale];
}

#pragma mark -
#pragma mark Make

- (void)makeLocale {
	[labelFooter setText:NSLocalizedString(@"loading_wait", @"")];
	[buttonClose setTitle:NSLocalizedString(@"close", @"Close") forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Set

- (void)setMessage:(NSString *)message title:(NSString *)title {
	[labelTitle setHidden:FALSE];
	[labelSubTitle setHidden:TRUE];
	[labelFooter setHidden:TRUE];
	[labelMessage setHidden:FALSE];
	[imageIcon setHidden:TRUE];
	[buttonClose setHidden:FALSE];
	
	[labelTitle setText:title];
	[labelMessage setText:message];
	[labelMessage alignTop];
	[labelMessage setCenter:CGPointMake(labelMessage.center.x, imageContent.center.y - 5.00f)];
	
	[self setShow:TRUE];
}

- (void)setLoading:(BOOL)show {
	[self setLoading:show title:@"" subtitle:@""];
}

- (void)setLoading:(BOOL)show title:(NSString *)title subtitle:(NSString *)subtitle {
	
	[labelTitle setHidden:FALSE];
	[labelSubTitle setHidden:FALSE];
	[labelFooter setHidden:FALSE];
	[labelMessage setHidden:TRUE];
	[imageIcon setHidden:FALSE];
	[buttonClose setHidden:TRUE];
	
	if (show) {
		[labelTitle setText:title];
		[labelSubTitle setText:subtitle];
	}
	
	[self setShow:show];
}

- (void)setShow:(BOOL)show {
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseOut animations:^{
		[self setAlpha:(show) ? 1.0f : 0.0f];
	} completion:^(BOOL finished) {
		
	}];
}

- (void)setFooterText:(NSString *)text {
	[labelFooter setText:text];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionClose {
	[self setShow:FALSE];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[super dealloc];
}

@end
