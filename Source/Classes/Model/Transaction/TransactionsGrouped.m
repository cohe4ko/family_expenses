//
//  TransactionsGrouped.m
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionsGrouped.h"
#import "CategoriesController.h"
#import "NSString+Utils.h"
#import "NSDate+Utils.h"
#import "NSDate+DateFunctions.h"
#import "SettingsController.h"

@implementation TransactionsGrouped

#pragma mark -
#pragma mark Initializate

@synthesize time, amount, groupStr, categoriesId;

+ (TransactionsGrouped *)withDictionary:(NSDictionary *)dic {
	return [[[TransactionsGrouped alloc] initWithDictionary:dic] autorelease];
}

- (TransactionsGrouped *)initWithDictionary:(NSDictionary *)dic {
	if (self == [super init]) {
        
	}
	return self;
}


#pragma mark -
#pragma mark Getters

- (NSDate *)date {
	return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSString *)price {
	NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
    
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
    
    return [NSString formatCurrency:self.amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
}

- (NSString*)dateAsWeekTimeInterval{
    NSInteger day = [self.date dayOfWeek];
    NSDate *d1 = [self.date addDays:-day+1];
    NSDate *d2 = [self.date addDays:7-day];
    if ([d1 year] != [d2 year]) {
        if ([self.date year] != [d1 year]) {
            d1 = [d1 addDays:-[self.date yearDay]+1];
        }else {
            d2 = [d2 addDays:-[d2 yearDay]];
        }
    }
    return [NSString stringWithFormat:@"%@ - %@ %d",[d1 dateFormat:NSLocalizedString(@"transactions_grouped_week_interval_format", @"")],[d2 dateFormat:NSLocalizedString(@"transactions_grouped_week_interval_format", @"")],[self.date year]];
}

- (Categories *)categories {
	return [CategoriesController getById:categoriesId];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    self.groupStr = nil;
	[super dealloc];
}

@end
