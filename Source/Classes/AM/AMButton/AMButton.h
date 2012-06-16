//
//  AMButton.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AMButtonTypeDefault	= 0,
	AMButtonTypeGreen = 1,
	AMButtonTypeBlue = 2
} AMButtonType;

@interface AMButton : UIButton {
	AMButtonType typeButton;
	BOOL isSet;
}

@property (nonatomic, assign) AMButtonType typeButton;

+ (id)withTypeButton:(AMButtonType)typeButton;

@end
