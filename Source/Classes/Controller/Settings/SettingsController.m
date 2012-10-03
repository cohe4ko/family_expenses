//
//  SettingsController.m
//  Expenses
//
//  Created by Sergey Vinogradov on 18.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsController.h"
#import "TransactionsController.h"
#import "NSDate+Utils.h"

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

+ (NSDictionary*)constractTransactionsDates{
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    IntervalType intervalType = [[NSUserDefaults standardUserDefaults] integerForKey:@"interval_selected"];
    
    if (intervalType == IntervalTypeDate) {
        beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_begin_date"];
        endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_end_date"];
        if (!beginDate) {
            beginDate = [TransactionsController minumDate];
            [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"transaction_filter_begin_date"];
        }
        if (!endDate) {
            endDate = [TransactionsController maximumDate];
            [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"transaction_filter_end_date"];
        }
    }else if(intervalType == IntervalTypeWeek){
        endDate = [[NSDate dateWithTimeIntervalSince1970:[NSDate todayUnixtime]] dateByAddingTimeInterval:24*3600-1];
        beginDate = [endDate dateByAddingTimeInterval:-7*24*3600];
    }else if(intervalType == IntervalTypeMonth){
        endDate = [[NSDate dateWithTimeIntervalSince1970:[NSDate todayUnixtime]] dateByAddingTimeInterval:24*3600-1];
        beginDate = [endDate dateByAddingTimeInterval:-31*24*3600];
    }else if(intervalType == IntervalTypeAll){
        beginDate = [TransactionsController minumDate];
        endDate = [TransactionsController maximumDate];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:beginDate,@"beginDate",endDate,@"endDate", nil];
}

+ (NSString *)UIID{
    NSString *uniqueID;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [[defaults objectForKey:@"uniqueID"] retain];
    if (uuid)
        uniqueID = (NSString *)uuid;
    else {
        CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
        uniqueID = (NSString *)cfUuid;
        [defaults setObject:uniqueID forKey:@"uniqueID"];
    }
    
    return [uniqueID autorelease];
}

@end