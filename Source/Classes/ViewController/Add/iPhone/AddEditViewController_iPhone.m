//
//  AddEditViewController_iPhone.m
//  Expenses
//

#import "AddEditViewController_iPhone.h"
#import "AddEditTableViewCell.h"

@interface AddEditViewController_iPhone (Private)
@end

@implementation AddEditViewController_iPhone

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
	Categories *m = [list objectAtIndex:indexPath.row];
	float height = 61.0f;
	if (m.isSelected)
		height += m.childs.count * 46.0f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifer = @"cellIdentifier";
	
	AddEditTableViewCell *cell = (AddEditTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddEditTableViewCell_iPhone" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	cell.parent = self;
	cell.isLast = (indexPath.row == [list count] - 1);
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

- (void)dealloc {
    [super dealloc];
}

@end