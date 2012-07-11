//
//  TransactionGroupViewControllerViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 05.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionGroupViewController.h"
#import "TransactionsController.h"

@interface TransactionGroupViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)loadData;
- (void)selectButtonWithTag:(NSInteger)tag;
- (void)deselectButtonWithTag:(NSInteger)tag;
- (void)deselectAllButtons;
- (void)clearAll;
- (void)initCurrentDate;
@end

@interface TransactionGroupViewController (Target)
- (void)firstDateTapped:(UITapGestureRecognizer*)sender;
- (void)secondDateTapped:(UITapGestureRecognizer*)sender;
@end

@implementation TransactionGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isShouldUpdate = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //make locales
    [self makeLocales];
    
    //make items
    [self makeItems];
    
    //load data
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self clearAll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Private
- (void)makeLocales{
    [labelTitle setText:NSLocalizedString(@"transactions_group_title", @"")];
    [daysButton setTitle:NSLocalizedString(@"transactions_group_day", @"") forState:UIControlStateNormal];
    [weeksButton setTitle:NSLocalizedString(@"transactions_group_week", @"") forState:UIControlStateNormal];
    [monthesButton setTitle:NSLocalizedString(@"transactions_group_month", @"") forState:UIControlStateNormal];
}

- (void)makeItems{
    [self deselectAllButtons];
    GroupType groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"group_transactions"];
    switch (groupType) {
        case GroupDay:
            [self selectButtonWithTag:100];
            break;
        case GroupWeek:
            [self selectButtonWithTag:101];
            break;
        case GroupMonth:
            [self selectButtonWithTag:102];
            break;
        case GroupInfin:
            [self selectButtonWithTag:103];
            break;
        default:
            break;
    }
    
    CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(20.0f, 10.0f, datePicker.frame.size.width - 40.0f, datePicker.frame.size.height - 20.0f)];
	[mask setCornerRadius:5.0f];
	[datePicker.layer setMask:mask];
	[mask release];
    
    [datePicker addTarget:self
                   action:@selector(actionPickerDateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *fTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(firstDateTapped:)];
    [firstCalendarView addGestureRecognizer:fTap];
    [fTap release];
    
    UITapGestureRecognizer *sTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(secondDateTapped:)];
    [secondCalendarView addGestureRecognizer:sTap];
    [sTap release];
    
    firstCalendarView.titleLabel.text = NSLocalizedString(@"transactions_group_date_cell_from", @"");
    secondCalendarView.titleLabel.text = NSLocalizedString(@"transactions_group_date_cell_to", @"");
    
}

- (void)loadData{
    [self initCurrentDate];
}

- (void)selectButtonWithTag:(NSInteger)tag{
}
- (void)deselectButtonWithTag:(NSInteger)tag{
    
}
- (void)deselectAllButtons{
    for (int i = 100; i<104; i++) {
        [self deselectButtonWithTag:i];
    }
}

- (void)initCurrentDate{
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_begin_date"];
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_end_date"];
    if (!beginDate) {
        beginDate = [TransactionsController minumDate];
        [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"transaction_filter_begin_date"];
    }
    if (!endDate) {
        endDate = [TransactionsController maximumDate];
        [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"transaction_filter_end_date"];
    }
    datePicker.date = beginDate;
    datePicker.maximumDate = endDate;
    firstCalendarView.detailLabel.text = [beginDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    secondCalendarView.detailLabel.text = [endDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
}

#pragma mark -

#pragma mark -
#pragma mark action

-(IBAction)actionDone:(id)sender{
    if (isShouldUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)actionGrouped:(id)sender{
    UIButton *b = (UIButton*)sender;
    if (selectedButton == b.tag) {
        return;
    }
    for (int i = 100;i<104;i++) {
        if (i!=b.tag) {
            [self deselectButtonWithTag:i];
        }
    }
    [self selectButtonWithTag:b.tag];
    switch (b.tag) {
        case 100:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupDay forKey:@"group_transactions"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupWeek forKey:@"group_transactions"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupMonth forKey:@"group_transactions"];
            break;
        case 103:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupInfin forKey:@"group_transactions"];
            break;
        default:
            break;
    }
    isShouldUpdate = YES;
}

- (void)firstDateTapped:(UITapGestureRecognizer*)sender{
    if (!firstCalendarView.selected) {
        firstCalendarView.selected = YES;
        secondCalendarView.selected = NO;
        NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_begin_date"];
        NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_end_date"];
        datePicker.date = beginDate;
        firstCalendarView.detailLabel.text = [beginDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
        datePicker.minimumDate = nil;
        datePicker.maximumDate = endDate;
        isShouldUpdate = YES;
    }
}
- (void)secondDateTapped:(UITapGestureRecognizer*)sender{
    if (!secondCalendarView.selected) {
        firstCalendarView.selected = NO;
        secondCalendarView.selected = YES;
        NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_begin_date"];
        NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"transaction_filter_end_date"];
        datePicker.date = endDate;
        secondCalendarView.detailLabel.text = [endDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
        datePicker.minimumDate = beginDate;
        datePicker.maximumDate = nil;
        isShouldUpdate = YES;
    }
}

- (void)actionPickerDateChanged:(id)sender{
    if (firstCalendarView.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:datePicker.date forKey:@"transaction_filter_begin_date"];
        firstCalendarView.detailLabel.text = [datePicker.date dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    }
    if (secondCalendarView.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:datePicker.date forKey:@"transaction_filter_end_date"];
        secondCalendarView.detailLabel.text = [datePicker.date dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    }
    isShouldUpdate = YES;
}

#pragma mark -

#pragma mark -
#pragma mark Memory management

- (void)clearAll{
    if (daysButton) {
        [daysButton release];
        daysButton = nil;
    }
    if (weeksButton) {
        [weeksButton release];
        weeksButton = nil;
    }
    if (monthesButton) {
        [monthesButton release];
        monthesButton = nil;
    }
    if (infinButton) {
        [infinButton release];
        infinButton = nil;
    }
    if (doneButton) {
        [doneButton release];
        doneButton = nil;
    }
    if (datePicker) {
        [datePicker release];
        datePicker = nil;
    }
    if (labelTitle) {
        [labelTitle release];
        labelTitle = nil;
    }
    
}

- (void)dealloc{
    [self clearAll];
    [super dealloc];
}

#pragma mark -

@end
