//
//  AMViewLoader.h
//  Expenses
//
//  Created by Vinogradov Sergey on 11.09.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMButton.h"

@interface AMViewLoader : UIView {
	IBOutlet AMButton *buttonClose;
	
	IBOutlet UILabel *labelTitle;
	IBOutlet UILabel *labelSubTitle;
	IBOutlet UILabel *labelMessage;
	IBOutlet UILabel *labelFooter;
	
	IBOutlet UIImageView *imageIcon;
	IBOutlet UIImageView *imageContent;
}

- (void)setMessage:(NSString *)message title:(NSString *)title;
- (void)setLoading:(BOOL)show;
- (void)setLoading:(BOOL)show title:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setShow:(BOOL)show;
- (void)setFooterText:(NSString *)text;

- (IBAction)actionClose;

@end
