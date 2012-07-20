//
//  PickerPasswordViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 20.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"

@interface PickerPasswordViewController : ViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UILabel *labelHeader;
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIButton *buttonDone;
    IBOutlet UIView *viewOverlay;
    
    BOOL isShouldUpdate;
}

@end
