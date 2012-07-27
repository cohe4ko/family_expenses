//
//  AMAnimationShake.h
//  iKilla
//
//  Created by Vinogradov Sergey on 30.03.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AMAnimationShake : NSObject {
	UIView *object;
}

@property(nonatomic,retain)UIView *object;

+ (id)shakeXWithObject:(UIView *)theObject;
- (id)initShakeXWithObject:(UIView *)theObject;

- (void)shakeX;
- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes;

@end
