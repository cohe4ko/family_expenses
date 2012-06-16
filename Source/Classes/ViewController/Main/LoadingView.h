//
//  LoadingView.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface LoadingView : UIView {
	UIView *view;
	UIView *viewBg;
	UIActivityIndicatorView *activity;
	UILabel *label;
	NSString *message;
}

@property (nonatomic, retain) NSString *message;

- (void)redraw:(UIInterfaceOrientation)interfaceOrientation;
- (void)changeRect;

@end

