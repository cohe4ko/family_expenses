//
//  PickerPasswordViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 20.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"
#import "ALPickerView.h"

@interface PickerPasswordViewController : ViewController<ALPickerViewDelegate>{
    IBOutlet UILabel *labelHeader;
    ALPickerView *pickerView;
    IBOutlet UIButton *buttonDone;
    IBOutlet UIView *viewOverlay;

    NSInteger initMode;
}

@end
