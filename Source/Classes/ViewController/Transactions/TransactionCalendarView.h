//
//  TransactionCalendarView.h
//  Expenses
//
//  Created by MacBook iAPPLE on 09.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCalendarView : UIView{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *detailLabel;
    BOOL selected;
}

@property(nonatomic,readwrite)BOOL selected;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *detailLabel;

@end
