//
//  UIAlertView+UIAlertView_Autorelease.h
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Autorelease)
+(void)showMessage:(NSString*)title forMessage:(NSString*)message forButtonTitle:(NSString*)buttonTitle;
@end
