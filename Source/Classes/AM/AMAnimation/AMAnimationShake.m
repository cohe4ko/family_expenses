//
//  AMAnimationShake.m
//  iKilla
//
//  Created by Vinogradov Sergey on 30.03.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMAnimationShake.h"

@implementation AMAnimationShake

+ (id)shakeXWithObject:(id)theObject {
	return [[[AMAnimationShake alloc] initShakeXWithObject:theObject] autorelease];
}

- (id)initShakeXWithObject:(id)theObject {
	if ((self = [super init])) {
		object = [theObject retain];
		[self shakeX];
	}
	return self;
}

- (void)shakeX {
	[self shakeXWithOffset:12.0 breakFactor:1.0f duration:0.8f maxShakes:4];
}

- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes {
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	[animation setDuration:aDuration];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:20];
	int infinitySec = maxShakes;
	while(aOffset > 0.01) {
		[keys addObject:[NSValue valueWithCGPoint:CGPointMake(object.center.x - aOffset, object.center.y)]];
		aOffset *= aBreakFactor;
		[keys addObject:[NSValue valueWithCGPoint:CGPointMake(object.center.x + aOffset, object.center.y)]];
		aOffset *= aBreakFactor;
		infinitySec--;
		if(infinitySec <= 0) {
			break;
		}
	}
	animation.values = keys;
	[object.layer addAnimation:animation forKey:@"position"];
}

- (void)dealloc {
	[object release];
	[super dealloc];
}

@end
