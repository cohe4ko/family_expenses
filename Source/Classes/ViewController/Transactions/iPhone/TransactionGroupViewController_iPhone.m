//
//  TransactionGroupViewController_iPhone.m
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionGroupViewController_iPhone.h"

@interface TransactionGroupViewController_iPhone ()

@end

@implementation TransactionGroupViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCalendarView" owner:self options:nil];
        firstCalendarView = [xib objectAtIndex:0];
        firstCalendarView.selected = YES;
        firstCalendarView.frame = CGRectMake(10, 70, 300, 50);
        [self.view addSubview:firstCalendarView];
        
        xib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCalendarView" owner:self options:nil];
        secondCalendarView = [xib objectAtIndex:0];
        secondCalendarView.selected = NO;
        secondCalendarView.frame = CGRectMake(10, 125, 300, 50);
        [self.view addSubview:secondCalendarView];
        
        UITapGestureRecognizer *fTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(firstDateTapped:)];
        [firstCalendarView addGestureRecognizer:fTap];
        [fTap release];
        
        UITapGestureRecognizer *sTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(secondDateTapped:)];
        [secondCalendarView addGestureRecognizer:sTap];
        [sTap release];
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

- (void)selectButtonWithTag:(NSInteger)tag{
    UIButton *b = (UIButton*)[self.view viewWithTag:tag];
    if (tag == 100) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateHighlighted];
    }else if (tag == 103) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood-selected.png"] forState:UIControlStateHighlighted];
    }else {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle-selected.png"] forState:UIControlStateHighlighted];
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
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle.png"] forState:UIControlStateHighlighted];
    }
}


@end
