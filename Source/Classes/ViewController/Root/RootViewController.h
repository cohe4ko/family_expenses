//
//  RootViewController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 06.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "TSAlertView.h"

@class AppDelegate;
@class LoadingView;
@class AlertViewController;
@class UserController;

@interface RootViewController : UIViewController <TSAlertViewDelegate, UIAlertViewDelegate> {

	IBOutlet UIView *viewConnection;
	IBOutlet UIView *viewSplash;
	
	IBOutlet UIImageView *imageViewSplash;
	
	IBOutlet UIActivityIndicatorView *indicatorSplash;
	
	IBOutlet UILabel *labelWarningTitle;
	IBOutlet UILabel *labelWarningSubtitle;
	IBOutlet UILabel *labelSplash;
	
	AppDelegate *master;
	LoadingView	*viewLoading;
	AlertViewController *alertController;
	
	NSString *connectionAuth;
	NSString *connectionHistory;
	NSString *connectionProducts;
	NSString *connectionCheckUpdate;
	
	BOOL stopView;
	BOOL isOrientationPortrait;
	BOOL isShowSplash;
	BOOL stopAlertNetwork;
	BOOL showAlertNetwork;
	
	SEL selectorAlert;
	
	id targetAlert;
}

@property (nonatomic, retain) UIView *viewConnection;
@property (nonatomic, retain) UIView *viewSplash;
@property (nonatomic, retain) UILabel *labelWarningTitle;
@property (nonatomic, retain) UILabel *labelWarningSubtitle;
@property (nonatomic, assign) AppDelegate *master;
@property (nonatomic, retain) LoadingView *viewLoading;
@property (nonatomic, assign) BOOL isOrientationPortrait;

+ (RootViewController *)shared;

- (void)run;

- (void)showSplash;
- (void)hideSplash;
- (void)splashMessage:(NSString *)text;

- (void)showLoading:(BOOL)show;
- (void)showLoading:(BOOL)show message:(NSString *)message;

- (void)showAlert:(NSString *)title message:(NSString *)message;
- (void)showAlert:(NSString *)title message:(NSString *)message target:(id)target selector:(SEL)selector;

- (void)alert:(NSString *)title message:(NSString *)message;
- (void)alert:(NSString *)title message:(NSString *)message target:(id)target selector:(SEL)selector;

@end
