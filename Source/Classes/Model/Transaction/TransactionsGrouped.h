//
//  TransactionsGrouped.h
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "DbObject.h"

@interface TransactionsGrouped : DbObject{
    NSInteger time;
    CGFloat amount;
}

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat amount;

+ (TransactionsGrouped *)withDictionary:(NSDictionary *)dic;
- (TransactionsGrouped *)initWithDictionary:(NSDictionary *)dic;
- (NSString *)price;
- (NSDate*)date;
- (NSString*)dateAsString;

@end
