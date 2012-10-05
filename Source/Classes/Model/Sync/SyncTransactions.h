//
//  SyncTransactions.h
//  Expenses
//
//  Created by Ruslan on 03.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "Model.h"

@interface SyncTransactions : DbObject{
    NSString *sid;
}

@property(nonatomic,retain)NSString *sid;

+ (SyncTransactions *)create;

- (BOOL)save;
- (void)remove;

@end
