//
//  AMViewSearch.h
//  Expenses
//
//  Created by Vinogradov Sergey on 18.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMButton.h"

@interface AMViewSearch : UIView <UITextFieldDelegate> {
	UIView *viewParent;
	UIView *view;
	UIView *viewOverlay;
	UITextField *textField;
	UIImageView *imageViewBackground;
	
	AMButton *buttonCancel;
	
	IBOutlet id parent;
	
	BOOL isSearch;
	BOOL disabledHide;
	BOOL keyboardIsShown;
}

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL disabledHide;
@property (nonatomic, retain) UITextField *textField;

- (void)setActive:(BOOL)active;

@end
