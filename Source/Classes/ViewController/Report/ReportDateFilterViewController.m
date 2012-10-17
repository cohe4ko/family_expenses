//
//  ReportDateFilterViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 09.08.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "ReportDateFilterViewController.h"
#import "TransactionsController.h"
#import "TransactionGroupViewControllerSubclass.h"
#import "SettingsController.h"

@interface ReportDateFilterViewController ()

@end

@implementation ReportDateFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Make
- (void)makeItems{
    [super makeItems];
    [self deselectAllButtons];
    IntervalType groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"report_group"];
    switch (groupType) {
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
}

#pragma mark - Init

- (void)initCurrentDate{
    NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    datePicker.date = beginDate;
    datePicker.maximumDate = endDate;
    firstCalendarView.detailLabel.text = [beginDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    secondCalendarView.detailLabel.text = [endDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
}

#pragma mark - Update

- (void)updateDate{
    NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
        
    [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"graph_filter_begin_date"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"graph_filter_end_date"];
    
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
#pragma mark action

-(IBAction)actionDone:(id)sender{
    if (isShouldUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPORT_UPDATE object:nil];
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
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeWeek forKey:@"report_group"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeMonth forKey:@"report_group"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeAll forKey:@"report_group"];
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
        [[NSUserDefaults standardUserDefaults] setObject:datePicker.date forKey:@"graph_filter_begin_date"];
        firstCalendarView.detailLabel.text = [datePicker.date dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    }
    if (secondCalendarView.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:datePicker.date forKey:@"graph_filter_end_date"];
        secondCalendarView.detailLabel.text = [datePicker.date dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
    }
    isShouldUpdate = YES;
    [self deselectAllButtons];
    [[NSUserDefaults standardUserDefaults] setInteger:IntervalTypeDate forKey:@"interval_selected"];
}


@end
