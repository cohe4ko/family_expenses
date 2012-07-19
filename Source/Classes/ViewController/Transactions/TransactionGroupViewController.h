//
//  TransactionGroupViewControllerViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 05.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"
#import "TransactionCalendarView.h"
#import <QuartzCore/QuartzCore.h>

@interface TransactionGroupViewController : ViewController{
    IBOutlet UIButton *daysButton;
    IBOutlet UIButton *weeksButton;
    IBOutlet UIButton *monthesButton;
    IBOutlet UIButton *infinButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UILabel *labelTitle;
    IBOutlet UIView *overlayView;
    TransactionCalendarView *firstCalendarView;
    TransactionCalendarView *secondCalendarView;
    NSInteger selectedButton;
    BOOL isShouldUpdate;
}

@end
