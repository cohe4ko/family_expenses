//
//  Model.h
//  Expenses
//
//  Created by Sergey Vinogradov on 06.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "Db.h"

@interface Model : Db {
	
}

+ (BOOL)addTransactionToSync:(NSString*)sid;
+ (BOOL)isTransactionToSyncExist:(NSString*)sid;
+ (NSArray*)allTransactionsToSync;

+ (BOOL)addBudgetToSync:(NSString*)sid;
+ (BOOL)isBudgetToSyncExist:(NSString*)sid;
+ (NSArray*)allBudgetsToSync;

@end
