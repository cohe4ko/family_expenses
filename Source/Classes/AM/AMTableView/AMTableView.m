//
//  AMTableView.m
//  Expenses
//
//  Created by Vinogradov Sergey on 01.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMTableView.h"

@implementation AMTableView

#pragma mark -
#pragma mark Touches event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[parent touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[parent release];
	[super dealloc];
}

@end
