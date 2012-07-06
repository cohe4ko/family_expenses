//
//  TransactionGroupViewControllerViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 05.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionGroupViewController.h"

@interface TransactionGroupViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)selectButtonWithTag:(NSInteger)tag;
- (void)deselectButtonWithTag:(NSInteger)tag;
- (void)deselectAllButtons;
@end

@implementation TransactionGroupViewController

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
    
    //make locales
    [self makeLocales];
    
    //make items
    [self makeItems];
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
}

- (void)selectButtonWithTag:(NSInteger)tag{
    UIButton *b = (UIButton*)[self.view viewWithTag:tag];
    if (tag == 100) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateHighlighted];
    }else if (tag == 103) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood-selected.png"] forState:UIControlStateHighlighted];
    }else {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateHighlighted];
    }
    selectedButton = b.tag;
}
- (void)deselectButtonWithTag:(NSInteger)tag{
    UIButton *b = (UIButton*)[self.view viewWithTag:tag];
    if (tag == 100) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateHighlighted];
    }else if (tag == 103) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood.png"] forState:UIControlStateHighlighted];
    }else {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateHighlighted];
    }
}
- (void)deselectAllButtons{
    for (int i = 100; i<104; i++) {
        [self deselectButtonWithTag:i];
    }
}

#pragma mark -

#pragma mark -
#pragma mark action

-(IBAction)actionDone:(id)sender{
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
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
}

#pragma mark -

@end
