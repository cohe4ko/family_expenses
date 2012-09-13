//
//  TransactionsGrouped.h
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "DbObject.h"
#import "Categories.h"

@interface TransactionsGrouped : DbObject{
    NSInteger time;
    CGFloat amount;
    NSString *groupStr;
    NSInteger categoriesId;
}

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger categoriesId;
@property (nonatomic, retain) NSString *groupStr;

+ (TransactionsGrouped *)withDictionary:(NSDictionary *)dic;
- (TransactionsGrouped *)initWithDictionary:(NSDictionary *)dic;
- (NSString *)price;
- (NSDate*)date;
- (NSString*)dateAsWeekTimeInterval;
- (Categories *)categories;

@end
