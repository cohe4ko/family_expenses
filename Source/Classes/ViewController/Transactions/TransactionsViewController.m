//
//  TransactionsViewController.m
//  Expenses
//

#import "TransactionsViewController.h"
#import "TransactionGroupViewController.h"
#import "TransactionsTableViewCell.h"

#import "TransactionsController.h"
#import "Transactions.h"

@interface TransactionsViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)loadData;
- (void)setData;
- (void)setClearEdit;
- (void)setTableViewFooter:(BOOL)animated;
- (void)setTotalAmount;
@end

@implementation TransactionsViewController

@synthesize sortType, groupType, isSort, list, cellEditing;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Register notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTransactionUpdate:) name:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
 	
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
#pragma mark Notifications

- (void)notificationTransactionUpdate:(NSNotification *)notification {
    if (groupType == GroupInfin) {
        [self setClearEdit];
    }
	self.groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"group_transactions"];
	[self loadData];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Add group button
	[self setButtonLeftWithImage:[UIImage imageNamed:@"icon_group.png"] withSelector:@selector(actionGroup)];
	
	// Set filter button
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_sort.png"] withSelector:@selector(actionSort)];
	
}

- (void)makeLocales {
	
	[labelHint setText:NSLocalizedString(@"transactions_hint", @"")];
	
	[labelSortHeader setText:NSLocalizedString(@"transactions_sort_header", @"")];
	
	[labelTotalName setText:NSLocalizedString(@"transactions_total", @"")];
	[labelTotalName sizeToFit];
	
	[buttonSortSumm setTitle:NSLocalizedString(@"transactions_sort_by_summ", @"") forState:UIControlStateNormal];
	[buttonSortDate setTitle:NSLocalizedString(@"transactions_sort_by_date", @"") forState:UIControlStateNormal];
	[buttonSortCategories setTitle:NSLocalizedString(@"transactions_sort_by_categories", @"") forState:UIControlStateNormal];
}

- (void)makeItems {
	
	CGRect r;
	
	self.cellEditing = [[NSMutableDictionary alloc] init];
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
	
	// Add sort
	[self.view addSubview:viewSort];
	[viewSort setAlpha:0.0f];
	r = viewSort.frame;
	r.origin.x = self.view.frame.size.width - r.size.width;
	r.origin.y = 0.0f;
	viewSort.frame = r;
	
	// Set buttons sort tag
	[buttonSortSumm setTag:SortSumm];
	[buttonSortDate setTag:SortDate];
	[buttonSortCategories setTag:SortCategores];
	
	// Set sort type
	self.sortType = [[NSUserDefaults standardUserDefaults] integerForKey:@"sort_transactions"];
    self.groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"group_transactions"];
}

#pragma mark -
#pragma mark Actions

- (void)actionGroup {
    TransactionGroupViewController *groupViewController = [MainController getViewController:@"TransactionGroupViewController"];
    [[RootViewController shared] presentModalViewController:groupViewController animated:YES];
}

- (void)actionSort {
	self.isSort = !self.isSort;
}

- (IBAction)actionSortButton:(UIButton *)sender {
	self.sortType = sender.tag;
	
	[self loadData];
}

#pragma mark -
#pragma mark Load

- (void)loadData {
	
	// Load transactions
    if (groupType == GroupInfin) {
        self.list = [TransactionsController loadTransactions:sortType];
    }else {
        self.list = [TransactionsController loadTransactions:sortType groupBy:groupType];
    }
	
	
	// Set data
	[self setData];
	
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	// Set tableview footer
	[self setTableViewFooter:NO];
	
	[self setTotalAmount];
	
	// Reload table view
	[tableView reloadData];
}

- (void)setSortType:(SortType)_sortType {
	if (sortType != _sortType) {
		sortType = _sortType;
		
		// Set sort buttons image
		[buttonSortSumm setImage:((sortType == SortSumm) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonSortDate setImage:((sortType == SortDate) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonSortCategories setImage:((sortType == SortCategores) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		
		// Hide sort
		self.isSort = NO;
		
		// Save sort
		[[NSUserDefaults standardUserDefaults] setInteger:sortType forKey:@"sort_transactions"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)setIsSort:(BOOL)_isSort {
	if (isSort != _isSort) {
		isSort = _isSort;
		
		[UIView animateWithDuration:0.3 animations:^{
			[viewSort setAlpha:(isSort) ? 1.0f : 0.0f];
		}];
	}
}

- (void)setTotalAmount {
	
	CGRect r;
	
	// Get total amount
	CGFloat amountTotal = 0;
	for (Transactions *m in self.list)
		amountTotal += m.amount;
	
	// Set total amount
	[labelTotal setText:[NSString stringWithFormat:@"%@ %@", [NSString formatCurrency:amountTotal def:@"0"], @"руб"]];
	[labelTotal sizeToFit];
	r = labelTotal.frame;
	if (r.size.width > 130.0f)
		r.size.width = 130.0f;
	r.size.height = 26.0f;
	r.origin.x = self.view.frame.size.width - r.size.width - 15.0f;
	labelTotal.frame = r;
	
	r = labelTotalName.frame;
	r.origin.x = labelTotal.frame.origin.x - r.size.width - 8.0f;
	r.origin.y = labelTotal.frame.origin.y;
	labelTotalName.frame = r;
	
	[labelTotal setAlpha:([self.list count] ? 1.0f : 0.0f)];
	[labelTotalName setAlpha:([self.list count] ? 1.0f : 0.0f)];
}

- (void)setTableViewFooter:(BOOL)animated {
	
	NSInteger count = [self.list count];
	if (count > 4)
		count = 4;
	
	[UIView animateWithDuration:((animated) ? 0.3f : 0.0f) animations:^{
		if (count) {
			CGRect r = imageNotepadFooter.frame;
			r.origin.y = tableView.frame.origin.y + 61.0f * count - 4.0f;
			imageNotepadFooter.frame = r;
		}
		[imageNotepadFooter setAlpha:(count ? 1.0f : 0.0f)];
		
	} completion:^(BOOL finished) {
		
		[self setTotalAmount];
		
		[tableView setScrollEnabled:([self.list count] > 4)];
	}];
}

- (void)setClearEdit {
	
	// Disable edit status
	[self.cellEditing removeAllObjects];
	
	for (TransactionsTableViewCell *cell in tableView.visibleCells)
		if (cell.edit)
			[cell setEdit:NO animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Disable edit state
    if (groupType == GroupInfin) {
        [self setClearEdit];
    }
	
}

- (void)tableView:(UITableView *)_tableView didRemoveCellAtIndexPath:(NSIndexPath *)indexPath {
	
	// Change state item
	Transactions *m = [self.list objectAtIndex:indexPath.row];
	[m remove];
	
	[cellEditing removeObjectForKey:[NSNumber numberWithInteger:m.Id]];
	
	// Remove item from list
	[self.list removeObjectAtIndex:indexPath.row];
	
	// Remove tableview cell
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(([self.list count]) ? UITableViewRowAnimationTop : UITableViewRowAnimationFade)];
	
	// Set tableview footer
	[self setTableViewFooter:YES];
}

- (void)tableView:(UITableView *)_tableView willSwipeCellAtIndexPath:(NSIndexPath *)indexPath {
	for (TransactionsTableViewCell *cell in _tableView.visibleCells) {
		NSIndexPath *indexPathCell = [_tableView indexPathForCell:cell];
		if (![indexPath isEqual:indexPathCell])
			[cell setEdit:NO animated:YES];
	}
}

#pragma mark -
#pragma mark Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	self.isSort = NO;
	
	[super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[labelHint release];
	labelHint = nil;
	[viewSort release];
	viewSort = nil;
	[labelSortHeader release];
	labelSortHeader = nil;
	[buttonSortSumm release];
	buttonSortSumm = nil;
	[buttonSortDate release];
	buttonSortDate = nil;
	[buttonSortCategories release];
	buttonSortCategories = nil;
    [tableView release];
    tableView = nil;
	[imageNotepadFooter release];
	imageNotepadFooter = nil;
	[labelDateStart release];
	labelDateStart = nil;
	[labelDateEnd release];
	labelDateEnd = nil;
	[labelTotal release];
	labelTotal = nil;
	[labelTotalName release];
	labelTotalName = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[labelHint release];
	[viewSort release];
	[labelSortHeader release];
	[buttonSortSumm release];
	[buttonSortDate release];
	[buttonSortCategories release];
	[list release];
    [tableView release];
	[imageNotepadFooter release];
	[labelDateStart release];
	[labelDateEnd release];
	[labelTotal release];
	[labelTotalName release];
    [super dealloc];
}

@end