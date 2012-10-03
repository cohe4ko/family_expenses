//
//  SyncBudget.h
//  Expenses
//
//  Created by Ruslan on 03.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "Model.h"

@interface SyncBudgets : DbObject{
    NSString *sid;
}

@property(nonatomic,retain)NSString *sid;

+ (SyncBudgets *)create;

- (BOOL)save;
- (void)remove;

@end
