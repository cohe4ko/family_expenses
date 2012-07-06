//
//  TransactionsGrouped.m
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionsGrouped.h"
#import "NSString+Utils.h"

@implementation TransactionsGrouped

#pragma mark -
#pragma mark Initializate

@synthesize time, amount, groupStr;

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
	return [NSString stringWithFormat:@"%@ %@", [NSString formatCurrency:self.amount def:@"0"], @"руб"];
}


#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    self.groupStr = nil;
	[super dealloc];
}

@end
