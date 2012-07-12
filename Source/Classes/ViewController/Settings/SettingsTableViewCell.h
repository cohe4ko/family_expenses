//
//  SettingsTableViewCell.h
//  Expenses
//
//  Created by Sergey Vinogradov on 09.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell {
    IBOutlet UILabel *detailLabel;
}

@property(nonatomic,readonly)UILabel *detailLabel;

@end
