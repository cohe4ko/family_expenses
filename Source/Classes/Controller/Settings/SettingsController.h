//
//  SettingsController.h
//  Expenses
//
//  Created by Sergey Vinogradov on 18.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "MainController.h"

#define kCurrencyKeyTitle @"Title"
#define kCurrencyKeySymbol @"Symbol"
#define kCurrencyKeyOrientation @"Orient"


@interface SettingsController : MainController {

}

+ (id)withDelegate:(id)theDelegate;

+ (void)loadCategories;
+ (NSDictionary*)currencyForIndex:(NSInteger)index;
+ (NSInteger)currencyCount;
+ (NSDictionary*)constractTransactionsDates;
+ (NSDictionary*)constractIntervalDates;
+ (NSString *)UIID;

@end
