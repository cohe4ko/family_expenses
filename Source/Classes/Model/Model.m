//
//  Model.m
//  Expenses
//
//  Created by Sergey Vinogradov on 06.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "Model.h"
#import "SyncBudget.h"
#import "SyncTransactions.h"

@implementation Model

#pragma mark - SetupDB

- (void)setupDB {
	NSLog(@"setupDB");
	[[Db shared] execute:@"DROP TABLE IF EXISTS Transactions"];
	[[Db shared] execute:@"CREATE TABLE Transactions (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, state INTEGER, repeatType INTEGER, repeatValue INTEGER, time INTEGER, categoriesId INTEGER, categoriesParentId INTEGER, amount REAL, desc TEXT, timestamp INTEGER, sid TEXT, device_id TEXT)"];
    [[Db shared] execute:@"DROP TABLE IF EXISTS Budget"];
	[[Db shared] execute:@"CREATE TABLE Budget (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, state INTEGER, repeat INTEGER, timeFrom INTEGER, timeTo INTEGER, amount REAL, categoriesId INTEGER, total REAL, timestamp INTEGER, sid TEXT, device_id TEXT)"];
}

#pragma mark - SyncDB

+ (BOOL)addTransactionToSync:(NSString*)sid{
    if (sid && ![Model isTransactionToSyncExist:sid]) {
        SyncTransactions *st = [SyncTransactions create];
        st.sid = sid;
        return [st save];
    }
    return NO;
}

+ (BOOL)isTransactionToSyncExist:(NSString*)sid{
    if (sid) {
        NSString *sql = [NSString stringWithFormat:@"select * from SyncTransactions where sid = \"%@\"",sid];
        NSArray *trs = [[Db shared] loadAndFill:sql theClass:[SyncTransactions class]];
        if (trs && [trs count] > 0) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray*)allTransactionsToSync{
    return [[Db shared] loadAndFill:@"select * from SyncTransactions" theClass:[SyncTransactions class]];
}

+ (BOOL)addBudgetToSync:(NSString*)sid{
    if (sid && ![Model isBudgetToSyncExist:sid]) {
        SyncBudgets *sb = [SyncBudgets create];
        sb.sid = sid;
        return [sb save];
    }
    return NO;
}

+ (BOOL)isBudgetToSyncExist:(NSString*)sid{
    if (sid) {
        NSString *sql = [NSString stringWithFormat:@"select * from SyncBudgets where sid = \"%@\"",sid];
        NSArray *budgets = [[Db shared] loadAndFill:sql theClass:[SyncBudgets class]];
        if (budgets && [budgets count] > 0) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray*)allBudgetsToSync{
    return [[Db shared] loadAndFill:@"select * from SyncBudgets" theClass:[SyncBudgets class]];
}

@end
