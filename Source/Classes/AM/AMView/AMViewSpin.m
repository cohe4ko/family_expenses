//
//  AMViewSpin.m
//  Expenses
//
//  Created by Vinogradov Sergey on 03.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMViewSpin.h"

@implementation AMViewSpin

@synthesize duration, hideWhenStopped;

#pragma mark -
#pragma mark Initializate

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
	[imageView setImage:image];
	[imageView sizeToFit];
}

- (void)setHideWhenStopped:(BOOL)stopped {
	hideWhenStopped = stopped;
	[imageView setHidden:stopped];
}

- (void)start {
	
	if (isSpinned)
		return;
	
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0f];
	animation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
	animation.duration = 5.0f;
	animation.repeatCount = INFINITY;
	[imageView.layer addAnimation:animation forKey:@"transform.rotation.z"];
	[imageView setHidden:FALSE];
	
	isSpinned = TRUE;
}

- (void)stop {
	
	if (!isSpinned)
		return;
	
	[imageView setHidden:hideWhenStopped];
	[imageView.layer removeAllAnimations];
	
	isSpinned = FALSE;
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[imageView release];
    [super dealloc];
}

@end
