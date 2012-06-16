//
//  SettingsViewController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SettingsViewController : ViewController <UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	
	NSMutableArray *list;
}

@end
