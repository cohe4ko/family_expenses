//
//  BudgetViewController_iPhone.m
//  Expenses
//

#import "BudgetViewController_iPhone.h"
#import "BudgetTableViewCell.h"

@interface BudgetViewController_iPhone (Private)
@end

@implementation BudgetViewController_iPhone

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
	return 61.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifer = @"cellIdentifier";
	
	BudgetTableViewCell *cell = (BudgetTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetTableViewCell_iPhone" owner:self options:nil];
		cell = [nib objectAtIndex:0];
		
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_row.png"]] autorelease];
	}
	
	cell.parent = self;
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