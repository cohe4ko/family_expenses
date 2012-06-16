//
//  SettingsViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController (Private)
- (void)makeToolBar;
- (void)makeLocale;
- (void)makeItems;
- (void)setData;
@end

@implementation SettingsViewController

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make toolbar
	[self makeToolBar];
	
	// Make locale
	[self makeLocale];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
}

- (void)makeLocale {
	
}

- (void)makeItems {
	
	// Init array
	list = [[NSMutableArray alloc] init];
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_login"] boolValue])
		[list addObject:@"contacts"];
	[list addObject:@"help"];
	[list addObject:@"feedback"];
	[list addObject:@"update"];
	
	[list removeAllObjects];
	
	// Set data
	[self setData];
}

#pragma mark -
#pragma mark UITableView delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Actions

#pragma mark -
#pragma mark Set

- (void)setData {
	
	// Reload tableview
	[tableView reloadData];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[list release];
    [super dealloc];
}

@end