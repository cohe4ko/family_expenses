//
//  SyncBudget.m
//  Expenses
//
//  Created by Ruslan on 03.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "SyncBudget.h"

@implementation SyncBudgets
@synthesize sid;

+ (SyncBudgets *)create{
    SyncBudgets *syncBud = [[[SyncBudgets alloc] init] autorelease];
    return syncBud;
}

- (BOOL)save{
    return [[Db shared] save:self];
}

- (void)remove{
    [[Db shared] del:self];
}
@end
