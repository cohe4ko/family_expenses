//
//  SettingsViewController_iPhone.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsViewController_iPhone.h"
#import "PickerCurrencyViewController_iPhone.h"
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [list count];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *sectionDic = [list objectAtIndex:section];
    return [[sectionDic objectForKey:@"list"] count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0f;
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
	NSDictionary *sectionDic = [list objectAtIndex:indexPath.section];
    NSArray *sectionList = [sectionDic objectForKey:@"list"];
    NSArray *cellTitles = [sectionList objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"settings_%@",[cellTitles objectAtIndex:0]];
    NSString *subtitle = [cellTitles objectAtIndex:1];
	cell.textLabel.text = NSLocalizedString(title, @"");
    cell.detailLabel.text = subtitle;
	
	return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSDictionary *sectionDic = [list objectAtIndex:section];
    NSString *title = [sectionDic objectForKey:@"title"];
    NSString *icon = [sectionDic objectForKey:@"icon"];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    iconImageView.frame = CGRectMake(10, 15, iconImageView.frame.size.width, iconImageView.frame.size.height);
    [headerView addSubview:iconImageView];
    [iconImageView release];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+iconImageView.frame.size.width, 8, 200, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:71.0/255.0 green:40.0/255.0 blue:6.0/255.0 alpha:1.0];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.text = NSLocalizedString(title, @"");
    [headerView addSubview:headerLabel];
    [headerLabel release];
    return [headerView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
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