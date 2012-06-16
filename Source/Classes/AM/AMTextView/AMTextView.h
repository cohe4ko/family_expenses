//
//  AMTextView.h
//  Expenses
//
//  Created by Vinogradov Sergey on 05.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTextView : UITextView <UITextViewDelegate> {
    NSString *_placeholder;
    UIColor *_placeholderColor;
	
    BOOL _shouldDrawPlaceholder;
	
	NSInteger numberOfLines;
}

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, retain) NSString *_textOld;

@end
