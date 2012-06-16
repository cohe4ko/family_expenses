//
//  SettingsController.m
//  Expenses
//
//  Created by Sergey Vinogradov on 18.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

+ (id)withDelegate:(id)theDelegate {
	return [[[SettingsController alloc] initWithDelegate:theDelegate] autorelease];
}

+ (void)loadCategories {
	
}

@end