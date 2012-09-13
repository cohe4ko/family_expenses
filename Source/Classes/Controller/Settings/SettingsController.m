//
//  SettingsController.m
//  Expenses
//
//  Created by Sergey Vinogradov on 18.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsController.h"

static NSArray *currencies = nil;

@implementation SettingsController

+ (id)withDelegate:(id)theDelegate {
	return [[[SettingsController alloc] initWithDelegate:theDelegate] autorelease];
}

+ (void)loadCategories {
	
}

+ (NSDictionary*)currencyForIndex:(NSInteger)index{
    if (!currencies) {
        currencies = [[NSArray alloc] initWithArray:[[self loadPlistAsDic:@"Currency"] objectForKey:@"Currency"]];
    }
    return [currencies objectAtIndex:index];
}

+ (NSInteger)currencyCount{
    if (!currencies) {
        currencies = [[NSArray alloc] initWithArray:[[self loadPlistAsDic:@"Currency"] objectForKey:@"Currency"]];
    }
    return [currencies count];
}

@end