//
//  SyncController.m
//  Expenses
//
//  Created by Ruslan on 08.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "SyncController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "Model.h"

static SyncController *sharedController = nil;

@implementation SyncController
@synthesize isSyncing;

+ (id)sharedSyncController{
    if (!sharedController) {
        sharedController = [[SyncController alloc] init];
    }
    return sharedController;
}

- (id)init{
    self = [super init];
    if (self) {
        isSyncing = NO;
    }
    return self;
}

- (void)sync{
    if (!self.isSyncing) {
        /*NSArray *transactions = [Model transactionsUsingSyncIds];
        NSArray *budgets = [Model budgetsUsingSyncIds];
        if ([transactions count] > 0 || [budgets count] > 0) {
            NSDictionary *syncDic = [NSDictionary dictionaryWithObjectsAndKeys:transactions,@"TransactionList",budgets, @"BudgetList", nil];
            NSString *jsonStr = [syncDic JSONRepresentation];
            NSLog(@"%@",jsonStr);
        }*/
        isSyncing = NO;
    }
}

@end
