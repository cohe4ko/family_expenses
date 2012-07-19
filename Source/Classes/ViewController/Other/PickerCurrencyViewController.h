//
//  PickerCurrencyViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    PointsNumberNo = 1,
    PointsNumberOne = 2,
    PointsNumberTwo = 3
}PointsNumber;

@interface PickerCurrencyViewController : ViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UIView *overlayView;
    IBOutlet UIPickerView *pickerView;
    IBOutlet UILabel *labelHeader;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *buttonTwoPoints;
    IBOutlet UIButton *buttonOnePoint;
    IBOutlet UIButton *buttonNoPoints;
    
    NSArray *codesArray;
    
    NSInteger selectedButton;
    BOOL isShouldUpdate;
    
}

@end
