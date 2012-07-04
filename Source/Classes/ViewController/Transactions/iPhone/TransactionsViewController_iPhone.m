//
//  TransactionsViewController_iPhone.m
//  Expenses
//

#import "TransactionsViewController_iPhone.h"
#import "AddBillViewController_iPhone.h"
#import "TransactionsTableViewCell.h"

@interface TransactionsViewController_iPhone (Private)
@end

@implementation TransactionsViewController_iPhone

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
	
	TransactionsTableViewCell *cell = (TransactionsTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionsTableViewCell_iPhone" owner:self options:nil];
		cell = [nib objectAtIndex:0];
		
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_row.png"]] autorelease];
	}
	
	cell.parent = self;
	cell.item = [list objectAtIndex:indexPath.row];
	
	return cell;
}

#pragma mark -
#pragma mark UITableView delegate
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:_tableView didSelectRowAtIndexPath:indexPath];
    AddBillViewController *controller = [MainController getViewController:@"AddBillViewController"];
    Transactions *item = [list objectAtIndex:indexPath.row];
    [controller setTransaction:item];
    [controller setAmount:item.amount];
    [controller setCategory:item.categories];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -

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