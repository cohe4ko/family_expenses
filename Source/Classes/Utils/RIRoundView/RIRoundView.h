//
//  RIRoundView.h
//  Expenses
//
//  Created by MacBook iAPPLE on 06.08.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIRoundView : UIView{
    CGFloat firstAngle;
    CGFloat secondAngle;
    UIColor *drawColor;
    CGFloat innerRadius;
    BOOL isDrawing;
}

- (id)initWithFrame:(CGRect)frame
         firstAngle:(CGFloat)fA
        secondAngle:(CGFloat)sA
        innerRadius:(CGFloat)iR
              color:(UIColor*)color;
- (void)resetValuesForFirstAngle:(CGFloat)fA secondAngle:(CGFloat)sA innerRadius:(CGFloat)iR color:(UIColor*)color;
- (void)drawFill:(BOOL)animating completion:(void (^)(void))onCompletionBlock;

@end
