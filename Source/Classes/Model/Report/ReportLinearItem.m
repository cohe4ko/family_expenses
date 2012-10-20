//
//  ReportLinearItems.m
//  Expenses
//
//  Created by Ruslan on 20.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ReportLinearItem.h"

@implementation ReportLinearItem
@synthesize time, amount, categoriesId, groupStr;

- (void)dealloc{
    self.groupStr = nil;
    [super dealloc];
}

@end
