//
//  SyncController.h
//  Expenses
//
//  Created by Ruslan on 08.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncController : NSObject{
    BOOL isSyncing;
}

+ (id)sharedSyncController;

- (void)sync;

@property(nonatomic,readonly)BOOL isSyncing;

@end
