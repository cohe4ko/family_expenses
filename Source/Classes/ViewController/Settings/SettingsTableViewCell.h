//
//  SettingsTableViewCell.h
//  Expenses
//
//  Created by Sergey Vinogradov on 09.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell {
	IBOutlet UIImageView *imageIcon;
	IBOutlet UILabel *labelName;
	
	NSString *item;
}

@property (nonatomic, retain) NSString *item;

@end
