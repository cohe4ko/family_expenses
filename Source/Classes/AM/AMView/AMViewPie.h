//
//  AMViewPie.h
//  Expenses
//
//  Created by Vinogradov Sergey on 17.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMViewPie : UIView {
@private
    CGFloat startSegment;
    CGFloat endSegment;    
    CGFloat radius;
    
    UIColor *color;
}

@property (nonatomic, retain) UIColor *color;

- (void)setValuesFromStart:(CGFloat)stVal toEnd:(CGFloat)endVal;

@end
