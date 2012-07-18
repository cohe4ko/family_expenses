//
//  UIAlertView+UIAlertView_Autorelease.m
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "UIAlertView+Autorelease.h"

@implementation UIAlertView (Autorelease)

+(void)showMessage:(NSString*)title forMessage:(NSString*)message forButtonTitle:(NSString*)buttonTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:buttonTitle
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
