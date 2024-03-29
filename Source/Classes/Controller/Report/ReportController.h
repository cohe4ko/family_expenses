//
//  ReportController.h
//  Expenses
//
//  Created by Ruslan on 20.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "MainController.h"

@interface ReportController : MainController

+ (NSMutableDictionary*)loadTransactionsForLinearGraphic:(GroupType)group minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (NSMutableArray*)loadTransactionsForPieGraphicWithCategoriesForMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (NSMutableArray*)loadTransactionsForPieGraphicWithSubcategoriesForMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (NSMutableArray*)loadDataForReportBoxForMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (CGFloat)maxAmountForLinearGraphicForGroup:(GroupType)group minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;

@end
