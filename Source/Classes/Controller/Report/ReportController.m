//
//  ReportController.m
//  Expenses
//
//  Created by Ruslan on 20.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ReportController.h"
#import "ReportLinearItem.h"
#import "ReportCategoryPieItem.h"
#import "ReportSubcategoryPieItem.h"
#import "Transactions.h"


@implementation ReportController

+ (NSMutableArray*)loadTransactionsForLinearGraphic:(GroupType)group minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate{
    NSString *groupField = @"";
    if (group == GroupDay) {
        groupField = @"t.time";
    }else if(group == GroupWeek){
        groupField = [NSString stringWithFormat:@"ObjcFormatAnsiDateUsingLocale_int('YYYY-ww', t.time, '%@')",[[NSLocale currentLocale] localeIdentifier]];
    }else if(group == GroupMonth){
        groupField = @"strftime('%Y%m', t.time, 'unixepoch')";
    }
	
    NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesParentId categoriesId, %@ groupStr FROM Transactions t WHERE state = %d and time >= %d and time <= %d GROUP BY groupStr, categoriesId", groupField, TransactionsStateNormal, (int)[minDate timeIntervalSince1970],(int)[maxDate timeIntervalSince1970]];
    
    return [[[[Db shared] loadAndFill:sql theClass:[ReportLinearItem class]] mutableCopy] autorelease];
}

+ (NSMutableArray*)loadTransactionsForPieGraphicWithCategoriesForMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate{
    NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesParentId categoriesId FROM Transactions t WHERE state = %d and time >= %d and time <= %d GROUP BY categoriesId", TransactionsStateNormal, (int)[minDate timeIntervalSince1970],(int)[maxDate timeIntervalSince1970]];
    
    return [[[[Db shared] loadAndFill:sql theClass:[ReportCategoryPieItem class]] mutableCopy] autorelease];
}

+ (NSMutableArray*)loadTransactionsForPieGraphicWithSubcategoriesForMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate{
    NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesId categoriesId, t.categoriesParentId categoriesParentId FROM Transactions t WHERE state = %d and time >= %d and time <= %d and categoriesId <> categoriesParentId  GROUP BY categoriesId", TransactionsStateNormal, (int)[minDate timeIntervalSince1970],(int)[maxDate timeIntervalSince1970]];
    
    return [[[[Db shared] loadAndFill:sql theClass:[ReportSubcategoryPieItem class]] mutableCopy] autorelease];
}

@end
