//
//  SettingsViewController_iPhone.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsViewController_iPhone.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController_iPhone (Private)
@end

@implementation SettingsViewController_iPhone

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITableView data source

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 56.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifer = @"cellIdentifier";
	
	SettingsTableViewCell *cell = (SettingsTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsTableViewCell_iPhone" owner:self options:nil];
		cell = [nib objectAtIndex:0];
		
		UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_accessory_view.png"]];
		[accessoryView setHighlightedImage:[UIImage imageNamed:@"tableview_accessory_view_highlighted.png"]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
	}
	
	cell.item = [list objectAtIndex:indexPath.row];
	
	return cell;
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
    [super dealloc];
}

@end