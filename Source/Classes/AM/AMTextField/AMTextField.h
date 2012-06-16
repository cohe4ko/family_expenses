//
//  AMTextField.h
//  Expenses
//
//  Created by Vinogradov Sergey on 11.09.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTextField : UITextField {
	int parentIdx;
	int idx;
	id object;
	
	float x;
}

@property (nonatomic, assign) int parentIdx;
@property (nonatomic, assign) int idx;
@property (nonatomic, retain) id object;

- (void)setBackgroundImage:(UIImage *)image;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setPromptText:(NSString *)aText;

@end
