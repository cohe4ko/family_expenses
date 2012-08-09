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
    GroupType groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"report_group"];
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
}

#pragma mark -
#pragma Init

- (void)initCurrentDate{
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_begin_date"];
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_end_date"];
    if (!beginDate) {
        beginDate = [TransactionsController minumDate];
        [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"graph_filter_begin_date"];
    }
    if (!endDate) {
        endDate = [TransactionsController maximumDate];
        [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"graph_filter_end_date"];
    }
    datePicker.date = beginDate;
    datePicker.maximumDate = endDate;
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
    for (int i = 100;i<104;i++) {
        if (i!=b.tag) {
            [self deselectButtonWithTag:i];
        }
    }
    [self selectButtonWithTag:b.tag];
    switch (b.tag) {
        case 100:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupDay forKey:@"report_group"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupWeek forKey:@"report_group"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupMonth forKey:@"report_group"];
            break;
        case 103:
            [[NSUserDefaults standardUserDefaults] setInteger:GroupInfin forKey:@"report_group"];
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
        NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_begin_date"];
        NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_end_date"];
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
        NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_begin_date"];
        NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_end_date"];
        datePicker.date = endDate;
        secondCalendarView.detailLabel.text = [endDate dateFormat:NSLocalizedString(@"transactions_group_date_cell_format", @"")];
        datePicker.minimumDate = beginDate;
        datePicker.maximumDate = nil;
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
}


@end
