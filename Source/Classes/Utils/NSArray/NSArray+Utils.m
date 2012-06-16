//
//  NSArray+Utils.m
//  Expenses
//
//  Created by Sergey Vinogradov on 24.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (BOOL)inArray:(NSString *)needle {
	for (NSString *s in self) {
		if ([s isEqualToString:needle]) {
			return YES;
		}
	}
	return NO;
}

@end
