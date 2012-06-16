//
//  AMViewSpin.h
//  Expenses
//
//  Created by Vinogradov Sergey on 03.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AMViewSpin : UIView {
	UIImageView *imageView;
	float duration;
	
	BOOL hideWhenStopped;
	BOOL isSpinned;
}

@property (nonatomic, assign) float duration;
@property (nonatomic, assign) BOOL hideWhenStopped;

- (void)setImage:(UIImage *)image;

- (void)start;
- (void)stop;

@end
