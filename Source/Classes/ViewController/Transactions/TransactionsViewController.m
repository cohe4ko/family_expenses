//
//  TransactionsViewController.m
//  Expenses
//

#import "TransactionsViewController.h"
#import "TransactionGroupViewController.h"
#import "TransactionsTableViewCell.h"

#import "TransactionsController.h"
#import "Transactions.h"
#import "NSLocale+Currency.h"
#import "SettingsController.h"


@interface TransactionsViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)updateTableViewHeader;
- (void)makeItems;
- (void)loadData;
- (void)loadTransactions:(NSDictionary*)params;
- (void)setData;
- (void)setClearEdit;
- (void)setTableViewFooter:(BOOL)animated;
- (void)setTotalAmount;
- (void)clean;
- (void)animatedAddObjectForIndex:(NSDictionary*)dic;
- (void)scrollToRowWithIndex:(NSNumber*)rIndex;
@end

@interface TransactionsViewController (Loading)
- (void)startLoading;
- (void)stopLoading;

@end

@implementation TransactionsViewController

@synthesize sortType, groupType, isSort, isGroup, list, cellEditing,addingTransaction;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Register notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTransactionUpdate:) name:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCurrencyChanged:) name:NOTIFICATION_CURRENCY_UPDATE object:nil];
 	
	// Make toolbar
	[self makeToolBar];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
    [self updateTableViewHeader];
    
	// Load data
	[self loadData];
}

- (void)addTransactionAnimated:(Transactions*)t{
    if (t && groupType == GroupInfin && list) {
        long foundIndex = -1;
        for (int i = 0; i < [list count]; i++) {
            Transactions *t1 = [list objectAtIndex:i];
            if (t1.Id == t.Id) {
                foundIndex = i;
                break;
            }
        }
        if (foundIndex >= 0) {
            [list removeObjectAtIndex:foundIndex];
            [tableView reloadData];
            
            if ([list count] > 0) {
                if (foundIndex == 0) {
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                         inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle
                                             animated:NO];
                }else if(foundIndex == [list count]) {
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:foundIndex-1
                                                                         inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle
                                             animated:NO];
                }else {
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:foundIndex
                                                                         inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle
                                             animated:NO];
                }
            }
            
            
            [self performSelector:@selector(animatedAddObjectForIndex:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:t,@"object",[NSNumber numberWithInt:foundIndex],@"index", nil] afterDelay:0.25];
            
        }
    }
}

- (void)animatedAddObjectForIndex:(NSDictionary*)dic{
    [list insertObject:[dic objectForKey:@"object"] atIndex:[[dic objectForKey:@"index"] intValue]];
    [tableView beginUpdates];
    
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[dic objectForKey:@"index"] intValue] inSection:0]]
                     withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates];
    
    [self performSelector:@selector(scrollToRowWithIndex:) withObject:[dic objectForKey:@"index"] afterDelay:0.25];
}

#pragma mark -
#pragma mark Notifications

- (void)notificationTransactionUpdate:(NSNotification *)notification {
    if (groupType == GroupInfin) {
        [self setClearEdit];
    }
	self.groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"group_transactions"];
    [self updateTableViewHeader];
	[self loadData];
    
}

- (void)notificationCurrencyChanged:(NSNotification*)notification{
    [self setData];
}

- (void)scrollToRowWithIndex:(NSNumber*)rIndex{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[rIndex intValue]
                                                         inSection:0]
                     atScrollPosition:UITableViewScrollPositionMiddle
                             animated:YES];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Add group button
	[self setButtonLeftWithImage:[UIImage imageNamed:@"icon_group.png"] withSelector:@selector(actionGroupType)];
	
	// Set filter button
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_sort.png"] withSelector:@selector(actionSort)];
	
}

- (void)makeLocales {
	
    [labelSortHeader setText:NSLocalizedString(@"transactions_sort_header", @"")];
    [labelGroupHeader setText:NSLocalizedString(@"transactions_group_header", @"")];
	
	[labelTotalName setText:NSLocalizedString(@"transactions_total", @"")];
	[labelTotalName sizeToFit];
	
	[buttonSortSumm setTitle:NSLocalizedString(@"transactions_sort_by_summ", @"") forState:UIControlStateNormal];
	[buttonSortDate setTitle:NSLocalizedString(@"transactions_sort_by_date", @"") forState:UIControlStateNormal];
	[buttonSortCategories setTitle:NSLocalizedString(@"transactions_sort_by_categories", @"") forState:UIControlStateNormal];
    [buttonGroupDay setTitle:NSLocalizedString(@"transactions_group_by_day", @"") forState:UIControlStateNormal];
	[buttonGroupWeek setTitle:NSLocalizedString(@"transactions_group_by_week", @"") forState:UIControlStateNormal];
	[buttonGroupMonth setTitle:NSLocalizedString(@"transactions_group_by_month", @"") forState:UIControlStateNormal];
    [buttonGroupAll setTitle:NSLocalizedString(@"transactions_group_by_all", @"") forState:UIControlStateNormal];
}

- (void)updateTableViewHeader{
    switch (groupType) {
        case GroupDay:
            [labelHint setText:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"transactions_hint_by_day", @"")]];
            break;
        case GroupMonth:
            [labelHint setText:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"transactions_hint_by_month", @"")]];
            break;
        case GroupWeek:
            [labelHint setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"transactions_hint_by_week", @"")]];
            break;
        case GroupInfin:
            [labelHint setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"transactions_hint", @"")]];
            break;
        default:
            break;
    }

}

- (void)makeItems {
	
    self.cellEditing = [NSMutableDictionary dictionary];
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
	
	    
    // Set buttons sort tag
	[buttonSortSumm setTag:SortSumm];
	[buttonSortDate setTag:SortDate];
	[buttonSortCategories setTag:SortCategores];
    
        
    //Set buttons group tag
    [buttonGroupDay setTag:GroupDay];
    [buttonGroupWeek setTag:GroupWeek];
    [buttonGroupMonth setTag:GroupMonth];
    [buttonGroupAll setTag:GroupInfin];
    
    loadingView.hidden = YES;
    

	// Set sort type
    sortType = -1;
	self.sortType = [[NSUserDefaults standardUserDefaults] integerForKey:@"sort_transactions"];
    groupType = -1;
    self.groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"group_transactions"];
    
    UITapGestureRecognizer *footterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionFooterTap)];
    [imageNotepadFooter addGestureRecognizer:footterTap];
    [footterTap release];
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionHeaderTap)];
    [imageNotepadHeader addGestureRecognizer:headerTap];
    [headerTap release];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionGroup {
    TransactionGroupViewController *groupViewController = [MainController getViewController:@"TransactionGroupViewController"];
    [[RootViewController shared] presentModalViewController:groupViewController animated:YES];
}

- (IBAction)actionSort {
	self.isSort = !self.isSort;
}

- (IBAction)actionSortButton:(UIButton *)sender {
	self.sortType = sender.tag;
	
	[self loadData];
}

- (IBAction)actionGroupType {
    self.isGroup = !self.isGroup;
}

- (IBAction)actionGroupButton:(UIButton*)sender{
    self.groupType = sender.tag;
    
    [self loadData];
}

- (void)actionFooterTap{
    if (list) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[list count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)actionHeaderTap{
    if (list && [list count] > 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark -
#pragma mark Load

- (void)loadData {
	
	// Load transactions
    NSDictionary *datesDic = [SettingsController constractTransactionsDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    labelDateStart.text = [beginDate dateFormat:NSLocalizedString(@"transactions_interval_date_format", @"")];
    labelDateEnd.text = [endDate dateFormat:NSLocalizedString(@"transactions_interval_date_format", @"")];
    self.list = [NSMutableArray array];
    // Set empty data
	[self setData];
    [self startLoading];
        
    /*[self performSelectorInBackground:@selector(loadTransactions:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:beginDate,@"beginDate",endDate,@"endDate", nil]];*/
    [self performSelector:@selector(loadTransactions:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:beginDate,@"beginDate",endDate,@"endDate", nil] afterDelay:0.25f];
}

- (void)loadTransactions:(NSDictionary*)params{

    if (groupType == GroupInfin) {
        self.list = [TransactionsController loadTransactions:sortType minDate:[params objectForKey:@"beginDate"] maxDate:[params objectForKey:@"endDate"]];
    }else {
        self.list = [TransactionsController loadTransactions:sortType groupBy:groupType minDate:[params objectForKey:@"beginDate"] maxDate:[params objectForKey:@"endDate"]];
    }

    [self stopLoading];
    [self setData];
    if (groupType == GroupInfin && self.addingTransaction) {
        [self addTransactionAnimated:self.addingTransaction];
        self.addingTransaction = nil;
    }else{
        if (list && currentIndex >= 0 && currentIndex < [list count]) {
            [self scrollToRowWithIndex:[NSNumber numberWithInt:currentIndex]];
            currentIndex = -1;
        }

    }
    
    

}

- (void)startLoading{
    [AppDelegate shared].tabBarController.view.userInteractionEnabled = NO;
    loadingView.hidden = NO;
    [loadingView startAnimating];
}

- (void)stopLoading{
    [loadingView stopAnimating];
    loadingView.hidden = YES;
    [AppDelegate shared].tabBarController.view.userInteractionEnabled = YES;
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

- (void)setLogo{
    [self setTitle:NSLocalizedString(@"nav_transactions", @"")];
}

- (void)setGroupType:(GroupType)_groupType{
    if (groupType != _groupType) {
		groupType = _groupType;
		
		// Set sort buttons image
		[buttonGroupDay setImage:((groupType == GroupDay) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonGroupWeek setImage:((groupType == GroupWeek) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonGroupMonth setImage:((groupType == GroupMonth) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
        
  		[buttonGroupAll setImage:((groupType == GroupInfin) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		
		// Hide group
		self.isGroup = NO;
		
		// Save group
		[[NSUserDefaults standardUserDefaults] setInteger:groupType forKey:@"group_transactions"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self updateTableViewHeader];
	}
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
        if (self.isGroup) {
            self.isGroup = NO;
        }
        if (isSort) {
           [[[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController] view] addSubview:viewSort];
            [UIView animateWithDuration:0.3 animations:^{
                viewSort.alpha = 1.0;
            } completion:^(BOOL finished){
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                viewSort.alpha = 0.0;
            } completion:^(BOOL finished){
                [viewSort removeFromSuperview];
            }];
        }
		
	}
}

- (void)setIsGroup:(BOOL)_isGroup{
    if (isGroup != _isGroup) {
		isGroup = _isGroup;
        if (self.isSort) {
            self.isSort = NO;    
            
        }
		
        if (isGroup) {
            [[[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController] view] addSubview:viewGroup];
            [UIView animateWithDuration:0.3 animations:^{
                viewGroup.alpha = 1.0;
            } completion:^(BOOL finished){
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                viewGroup.alpha = 0.0;
            } completion:^(BOOL finished){
                [viewGroup removeFromSuperview];
            }];
        }
        
	}
}

- (void)setTotalAmount {
	
	CGRect r;
	
	// Get total amount
	CGFloat amountTotal = 0;
	for (Transactions *m in self.list)
		amountTotal += m.amount;
	
	// Set total amount
    NSInteger currencyIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"settings_currency_index"] integerValue];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    NSDictionary *currencyDic = [SettingsController currencyForIndex:currencyIndex];
	[labelTotal setText:[NSString formatCurrency:amountTotal currencyCode:[currencyDic objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currencyDic objectForKey:kCurrencyKeyOrientation] intValue]]];
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
    if (groupType != GroupInfin) {
        TransactionsGrouped *groupTransaction = [list objectAtIndex:indexPath.row];
        NSDate *dateFrom = [groupTransaction dateFromForGroupType:groupType];
        NSDate *dateTo = [groupTransaction dateToForGroupType:groupType];

        [self setGroupType:GroupInfin];
        [[NSUserDefaults standardUserDefaults] setObject:dateFrom forKey:@"transaction_filter_begin_date"];
        [[NSUserDefaults standardUserDefaults] setObject:dateTo forKey:@"transaction_filter_end_date"];
        [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeDate forKey:@"interval_selected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [labelHint setText:[NSString stringWithFormat:NSLocalizedString(@"transactions_hint_by_date", @""),[dateFrom dateFormat:NSLocalizedString(@"transactions_hint_date_format", @"")],[dateTo dateFormat:NSLocalizedString(@"transactions_hint_date_format", @"")]]];
        [self loadData];
    }else{
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
	self.isGroup = NO;
	[super touchesEnded:touches withEvent:event];
}

#pragma mark - Gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[self clean];
	[super viewDidUnload];
}

- (void)clean{
    if (labelHint) {
        [labelHint release];
        labelHint = nil;
    }
    if (viewSort) {
        [viewSort release];
        viewSort = nil;
    }
	if (viewGroup) {
        [viewGroup release];
        viewGroup = nil;
    }
    if (labelSortHeader) {
        [labelSortHeader release];
        labelSortHeader = nil;
    }
	if (labelGroupHeader) {
        [labelGroupHeader release];
        labelGroupHeader = nil;
    }
    if (buttonSortSumm) {
        [buttonSortSumm release];
        buttonSortSumm = nil;
    }
    if (buttonSortDate) {
        [buttonSortDate release];
        buttonSortDate = nil;
    }
    if (buttonSortCategories) {
        [buttonSortCategories release];
        buttonSortCategories = nil;
    }
    if (buttonGroupAll) {
        [buttonGroupAll release];
        buttonGroupAll = nil;
    }
    if (buttonGroupDay) {
        [buttonGroupDay release];
        buttonGroupDay = nil;
    }
    if (buttonGroupWeek) {
        [buttonGroupWeek release];
        buttonGroupWeek = nil;
    }
    if (buttonGroupMonth) {
        [buttonGroupMonth release];
        buttonGroupMonth = nil;
    }
    if (tableView) {
        [tableView release];
        tableView = nil;
    }
    if (imageNotepadFooter) {
        [imageNotepadFooter release];
        imageNotepadFooter = nil;
    }
    if (imageNotepadHeader) {
        [imageNotepadHeader release];
        imageNotepadHeader = nil;
    }
    if (labelDateStart) {
        [labelDateStart release];
        labelDateStart = nil;
    }
	if (labelDateEnd) {
        [labelDateEnd release];
        labelDateEnd = nil;
    }
	if (labelTotal) {
        [labelTotal release];
        labelTotal = nil;
    }
    if (labelTotalName) {
        [labelTotalName release];
        labelTotalName = nil;
    }
	if (loadingView) {
        [loadingView release];
        loadingView = nil;
    }
	self.addingTransaction = nil;
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self clean];
    [super dealloc];
}

@end