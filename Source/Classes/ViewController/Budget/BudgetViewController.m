//
//  BudgetViewController.m
//  Expenses
//

#import "BudgetViewController.h"
#import "BudgetEditViewController.h"
#import "BudgetTableViewCell.h"
#import "BudgetController.h"
#import "Budget.h"

@interface BudgetViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation BudgetViewController

@synthesize list, cellEditing;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Register notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NOTIFICATION_BUDGET_UPDATE object:nil];
 	
	// Make toolbar
	[self makeToolBar];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Load data
	[self loadData];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Set button add
	[self setButtonLeftWithImage:[UIImage imageNamed:@"icon_add.png"] withSelector:@selector(actionAdd)];
	
	// Set button edit
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_edit.png"] withSelector:@selector(actionEdit)];
}

- (void)makeLocales {
	
	// Set hint
	[labelHint setText:NSLocalizedString(@"budget_hint", @"")];
	
}

- (void)makeItems {
	
	self.cellEditing = [[NSMutableDictionary alloc] init];
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
}

#pragma mark -
#pragma mark Actions

- (void)actionAdd {
	BudgetEditViewController *controller = [MainController getViewController:@"BudgetEditViewController"];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)actionEdit {
	isEdit = !isEdit;

	for (BudgetTableViewCell *cell in tableView.visibleCells)
		[cell setEdit:isEdit animated:YES];
}

#pragma mark -
#pragma mark Load

- (void)loadData {
	
	// Load budget
	self.list = [BudgetController loadBudget];
	
	[tableView reloadData];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
}

- (void)setClearEdit {
	
	// Disable edit status
	[self.cellEditing removeAllObjects];
	
	for (BudgetTableViewCell *cell in tableView.visibleCells)
		if (cell.edit)
			[cell setEdit:NO animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Disable edit state
	if (!isEdit) {
		
		BudgetEditViewController *controller = [MainController getViewController:@"BudgetEditViewController"];
		[controller setBudget:[self.list objectAtIndex:indexPath.row]];
		[controller setHidesBottomBarWhenPushed:YES];
		[self.navigationController pushViewController:controller animated:YES];
		
		[self setClearEdit];
	}
}

- (void)tableView:(UITableView *)_tableView didRemoveCellAtIndexPath:(NSIndexPath *)indexPath {
	
	// Change state item
	Budget *m = [self.list objectAtIndex:indexPath.row];
	[m remove];
	
	[cellEditing removeObjectForKey:[NSNumber numberWithInteger:m.Id]];
	
	// Remove item from list
	[self.list removeObjectAtIndex:indexPath.row];
	
	// Remove tableview cell
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(([self.list count]) ? UITableViewRowAnimationTop : UITableViewRowAnimationFade)];
	
	if (!self.list.count)
		isEdit = NO;
}

- (void)tableView:(UITableView *)_tableView willSwipeCellAtIndexPath:(NSIndexPath *)indexPath {
	
	if (isEdit)
		return;
	
	for (BudgetTableViewCell *cell in _tableView.visibleCells) {
		NSIndexPath *indexPathCell = [_tableView indexPathForCell:cell];
		if (![indexPath isEqual:indexPathCell])
			[cell setEdit:NO animated:YES];
	}
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[tableView release];
	tableView = nil;
	[labelHint release];
	labelHint = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[list release];
	[tableView release];
	[labelHint release];
	[cellEditing release];
    [super dealloc];
}

@end