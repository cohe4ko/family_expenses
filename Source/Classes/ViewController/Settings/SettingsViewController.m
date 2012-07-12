//
//  SettingsViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_settings",@"title", @"icon_settings_settings.png", @"icon", nil];
	NSMutableArray *settingsArray = [NSMutableArray array];
    [settingsArray addObject:[NSArray arrayWithObjects:@"password",@"", nil]];
	[settingsArray addObject:[NSArray arrayWithObjects:@"currency",@"Рубль", nil]];
    [settingsDic setObject:settingsArray forKey:@"list"];
    [list addObject:settingsDic];
    
    NSMutableDictionary *devicesDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_devices", @"title", @"icon_settings_device.png", @"icon", nil];
    NSMutableArray *devicesArray = [NSMutableArray array];
    [devicesArray addObject:[NSArray arrayWithObjects:@"devices",@"", nil]];
    [devicesDic setObject:devicesArray forKey:@"list"];
    [list addObject:devicesDic];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_database", @"title", @"icon_settings_database.png", @"icon", nil];
    NSMutableArray *sendArray = [NSMutableArray array];
    [sendArray addObject:[NSArray arrayWithObjects:@"clear_database",@"", nil]];
    [sendArray addObject:[NSArray arrayWithObjects:@"send_by_email",@"", nil]];
    [sendDic setObject:sendArray forKey:@"list"];
    [list addObject:sendDic];
    
	tableView.separatorColor = [UIColor colorWithRed:77.0/255.0 green:31.0/255.0 blue:23.0/255.0 alpha:1.0];

	
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