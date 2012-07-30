//
//  PasswordViewController.h
//  Expenses
//
//  Created by MacBook iAPPLE on 24.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"

typedef enum {
 PasswordEditTypeCheck,
 PasswordEditTypeAdd,
 PasswordEditTypeReplace   
}PasswordEditType;

@interface PasswordViewController : ViewController{
    IBOutlet UIImageView *viewTopShutter;
    IBOutlet UIImageView *viewBottomShutter;
    IBOutlet UIButton *buttonSave;
    IBOutlet UIButton *buttonCancel;
    IBOutlet UILabel *labelHeader;
    IBOutlet UILabel *labelCode1;
    IBOutlet UILabel *labelCode2;
    IBOutlet UILabel *labelCode3;
    IBOutlet UILabel *labelCode4;
    IBOutlet UILabel *labelTopTitle;
    IBOutlet UIButton *buttonBarCancel;
    IBOutlet UIView *contentView;
    IBOutlet UIView *viewTopBar;
    PasswordEditType editType;
    NSInteger step;
    NSInteger code;
    NSInteger newCode;
    NSInteger notCorEntCount;
}


@property(nonatomic,readwrite)PasswordEditType editType;

@end
