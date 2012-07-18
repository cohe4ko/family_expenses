//
//  ViewController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 24.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

#import "MainController.h"

#import "AMButton.h"
#import "AMButtonBack.h"
#import "AMTextField.h"
#import "AMTextFieldNumberPad.h"

#import "UILabel+Utils.h"
#import "UIColor-Expanded.h"

#import "NSString+Utils.h"
#import "NSDate+Utils.h"
#import "UIAlertView+Autorelease.h"

#import "DataManager.h"
#import "Constants.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate> {
	UIImageView *imageNavigationbarShadow;
	UIImageView *imageTabbarShadow;
	
	IBOutlet UILabel *labelMessageConnection;

	int index;
	
	BOOL connectionStatus;
	BOOL keyboardIsShown;
}

@property (nonatomic, assign) int index;

- (void)setTabbarShadowHide;

- (void)setButtonLeft:(NSString *)theTitle withSelector:(SEL)selector;
- (void)setButtonLeftWithImage:(UIImage *)theImage withSelector:(SEL)selector;
- (void)setButtonLeftWithImage:(UIImage *)theImage withSelector:(SEL)selector withType:(AMButtonType)type;
- (void)setButtonRight:(NSString *)theTitle withSelector:(SEL)selector;
- (void)setButtonRight:(NSString *)theTitle withSelector:(SEL)selector withType:(AMButtonType)type;
- (void)setButtonRightWithImage:(UIImage *)theImage withSelector:(SEL)selector;
- (void)setButtonRightWithImage:(UIImage *)theImage withSelector:(SEL)selector withType:(AMButtonType)type;
- (void)setButtonBack;
- (void)setButtonBack:(NSString *)theTitle;

- (IBAction)actionBack;
- (void)updateConnection:(BOOL)connection;

@end
