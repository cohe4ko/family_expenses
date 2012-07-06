//
//  TransactionGroupedTableViewCell.h
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionsGrouped.h"

@interface TransactionGroupedTableViewCell : UITableViewCell{
    IBOutlet UIImageView *categoryImageView;
    IBOutlet UILabel *labelDate;
    IBOutlet UILabel *labelPrice;
    IBOutlet UIView *viewContent;
    TransactionsGrouped *item;
}

-(void)setTransaction:(TransactionsGrouped*)_item dateFormat:(NSString*)dateFormat;

@end
