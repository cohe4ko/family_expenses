//
//  AMButtonObject.m
//  Expenses
//
//  Created by Vinogradov Sergey on 11.09.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMButtonObject.h"

@implementation AMButtonObject

@synthesize object;

- (void)dealloc {
	[object release];
	[super dealloc];
}

@end
