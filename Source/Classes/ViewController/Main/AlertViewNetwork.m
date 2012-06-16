//
//  AlertViewNetwork.m
//  FindAndCall
//
//  Created by Vinogradov Sergey on 07.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AlertViewNetwork.h"

@implementation AlertViewNetwork

- (id)initWithObject:(id)_object {
	object = [_object retain];
	if (self == [super initWithTitle:NSLocalizedString(@"network_error_title", @"") message:NSLocalizedString(@"network_error_message", @"") delegate:object cancelButtonTitle:NSLocalizedString(@"network_error_button_cancel", @"") otherButtonTitles:NSLocalizedString(@"network_error_button_repeat", @""), nil]) {
	}
	return self;
}

@end
