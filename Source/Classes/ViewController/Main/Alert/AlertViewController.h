//
//  AlertViewController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 08.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AlertViewController : ViewController {
	IBOutlet UIView *viewOpacity;
	IBOutlet UIView *viewContent;
	IBOutlet UIView *viewTop;
	IBOutlet UIView *viewBottom;
	
	IBOutlet UILabel *labelTitle;
	IBOutlet UILabel *labelMessage;
	
	IBOutlet AMButton *button;
	
	id target;
	SEL selector;
}

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL selector;

- (void)setTitle:(NSString *)theTitle;
- (void)setMessage:(NSString *)message;

- (void)show;
- (void)hide;

- (IBAction)actionClose;

@end
