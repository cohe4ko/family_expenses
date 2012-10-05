//
//  SyncTransactions.m
//  Expenses
//
//  Created by Ruslan on 03.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "SyncTransactions.h"

@implementation SyncTransactions
@synthesize sid;

+ (SyncTransactions *)create{
    SyncTransactions *syncTr = [[[SyncTransactions alloc] init] autorelease];
    return syncTr;
}

- (BOOL)save{
    return [[Db shared] save:self];
}

- (void)remove{
    [[Db shared] del:self];
}


@end
