//
//  TransactionGroupViewControllerSubclass.h
//  Expenses
//
//  Created by MacBook iAPPLE on 09.08.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#ifndef Expenses_TransactionGroupViewControllerSubclass_h
#define Expenses_TransactionGroupViewControllerSubclass_h

@interface TransactionGroupViewController ()
- (void)makeLocales;
- (void)makeItems;
- (void)loadData;
- (void)selectButtonWithTag:(NSInteger)tag;
- (void)deselectButtonWithTag:(NSInteger)tag;
- (void)deselectAllButtons;
- (void)clearAll;
- (void)initCurrentDate;
- (void)updateDate;
@end

#endif
