//
//  TransactionGroupViewControllerViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 05.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"

@interface TransactionGroupViewController : ViewController{
    IBOutlet UIButton *daysButton;
    IBOutlet UIButton *weeksButton;
    IBOutlet UIButton *monthesButton;
    IBOutlet UIButton *infinButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UILabel *labelTitle;
}

@end
