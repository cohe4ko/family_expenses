//
//  AMScrollView.m
//  Expenses
//
//  Created by Vinogradov Sergey on 16.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMScrollView.h"

@implementation AMScrollView

#pragma mark -
#pragma mark Touches event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// If not dragging, send event to next responder
	if (!self.dragging) {
		[parent touchesEnded:touches withEvent:event];
		[self.nextResponder touchesEnded:touches withEvent:event]; 
	}
	else
		[super touchesEnded: touches withEvent: event];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[parent release];
	[super dealloc];
}

@end
