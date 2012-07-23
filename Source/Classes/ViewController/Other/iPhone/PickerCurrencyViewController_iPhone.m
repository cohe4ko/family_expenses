//
//  PickerCurrencyViewController_iPhoneViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PickerCurrencyViewController_iPhone.h"

@interface PickerCurrencyViewController_iPhone ()

@end

@implementation PickerCurrencyViewController_iPhone

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
#pragma Private

- (void)selectButtonWithTag:(NSInteger)tag{
    UIButton *b = (UIButton*)[self.view viewWithTag:tag];
    if (tag == PointsNumberNo) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood-selected.png"] forState:UIControlStateHighlighted];
    }else if (tag == PointsNumberTwo) {
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
    if (tag == PointsNumberNo) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_left_wood.png"] forState:UIControlStateHighlighted];
    }else if (tag == PointsNumberTwo) {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segmented_right_wood.png"] forState:UIControlStateHighlighted];
    }else {
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle.png"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"button_segment_middle.png"] forState:UIControlStateHighlighted];
    }
}

@end
