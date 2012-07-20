//
//  PickerPasswordViewController_iPhone.m
//  Expenses
//
//  Created by MacBook iAPPLE on 20.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PickerPasswordViewController_iPhone.h"

@interface PickerPasswordViewController_iPhone ()

@end

@implementation PickerPasswordViewController_iPhone

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

@end
