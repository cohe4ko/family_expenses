//
//  TabBarController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTabBarController.h"

@class Transactions;

@interface TabBarController : BCTabBarController{
    NSInteger shouldOpenIndexAfterPassword;
}

- (void)loadTabs;
- (void)animationTransactionAdding:(Transactions*)t;

@end
