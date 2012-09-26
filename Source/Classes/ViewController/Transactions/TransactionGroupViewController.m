//
//  TransactionGroupViewControllerViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 05.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionGroupViewController.h"
#import "TransactionsController.h"
#import "SettingsController.h"

@interface TransactionGroupViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)loadData;
- (void)selectButtonWithTag:(NSInteger)tag;
- (void)deselectButtonWithTag:(NSInteger)tag;
- (void)deselectAllButtons;
- (void)clearAll;
- (void)initCurrentDate;
- (void)updateDate;
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
    
    [imageNavigationbarShadow setHidden:YES];
    
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

- (void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.3 animations:^{
		[overlayView setAlpha:1.0f];
	}];
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Private
- (void)makeLocales{
    [labelTitle setText:NSLocalizedString(@"transactions_group_title", @"")];
    [weeksButton setTitle:NSLocalizedString(@"transactions_group_week", @"") forState:UIControlStateNormal];
    [monthesButton setTitle:NSLocalizedString(@"transactions_group_month", @"") forState:UIControlStateNormal];
}

- (void)makeItems{
    [self deselectAllButtons];
    IntervalType intervalType = [[NSUserDefaults standardUserDefaults] integerForKey:@"interval_selected"];
    switch (intervalType) {
        case IntervalTypeWeek:
            [self selectButtonWithTag:100];
            break;
        case IntervalTypeMonth:
            [self selectButtonWithTag:101];
            break;
        case IntervalTypeAll:
            [self selectButtonWithTag:102];
            break;
        default:
            break;
    }
    
    CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(20.0f, 10.0f, datePicker.frame.size.width - 40.0f, datePicker.frame.size.height - 15.0f)];
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
    NSDictionary *datesDic = [SettingsController constractTransactionsDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    

    datePicker.date = beginDate;
    datePicker.maximumDate = endDate;
    firstCalendarView.detailLabel.text = [beginDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    secondCalendarView.detailLabel.text = [endDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
}

- (void)updateDate{
    NSDictionary *datesDic = [SettingsController constractTransactionsDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
        
    [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"transaction_filter_begin_date"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"transaction_filter_end_date"];
    
    if (firstCalendarView.selected) {
        datePicker.date = beginDate;
        datePicker.minimumDate = nil;
        datePicker.maximumDate = endDate;
    }else{
        datePicker.date = endDate;
        datePicker.minimumDate = beginDate;
        datePicker.maximumDate = nil;
    }
    
    
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
    [UIView animateWithDuration:0.2 animations:^{
		[overlayView setAlpha:0.0f];
	} completion:^(BOOL finished) {
		[self dismissModalViewControllerAnimated:YES];
	}];
    
}

-(IBAction)actionGrouped:(id)sender{
    UIButton *b = (UIButton*)sender;
    if (selectedButton == b.tag) {
        return;
    }
    for (int i = 100;i<103;i++) {
        if (i!=b.tag) {
            [self deselectButtonWithTag:i];
        }
    }
    [self selectButtonWithTag:b.tag];
    switch (b.tag) {
        case 100:
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeWeek forKey:@"interval_selected"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeMonth forKey:@"interval_selected"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeAll forKey:@"interval_selected"];
            break;
        default:
            break;
    }
    isShouldUpdate = YES;
    [self updateDate];
}

- (void)firstDateTapped:(UITapGestureRecognizer*)sender{
    if (!firstCalendarView.selected) {
        firstCalendarView.selected = YES;
        secondCalendarView.selected = NO;
        [self updateDate];
        isShouldUpdate = YES;
    }
}
- (void)secondDateTapped:(UITapGestureRecognizer*)sender{
    if (!secondCalendarView.selected) {
        firstCalendarView.selected = NO;
        secondCalendarView.selected = YES;
        [self updateDate];
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
    [self deselectAllButtons];
    [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeDate forKey:@"interval_selected"];
}

#pragma mark -

#pragma mark -
#pragma mark Memory management

- (void)clearAll{
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
    if (overlayView) {
        [overlayView release];
        overlayView = nil;
    }
}

- (void)dealloc{
    [self clearAll];
    [super dealloc];
}

#pragma mark -

@end
