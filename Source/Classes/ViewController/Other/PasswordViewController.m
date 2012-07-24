//
//  PasswordViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 24.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()
- (void)makeItems;
- (void)makeLocale;
- (void)prepareViews;
- (void)showViews;
@end

@implementation PasswordViewController

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
    if (editType == PasswordEditTypeCheck) {
        buttonSave.hidden = YES;
        buttonCancel.hidden = YES;
    }
}

- (void)makeLocale{

}

#pragma mark -

#pragma mark -
#pragma mark Action
- (IBAction)actionSave:(UIButton*)sender{
    
}

- (IBAction)actionCancel:(UIButton*)sender{
    
}

- (IBAction)actionNumberPressed:(UIButton*)sender{
    
}

#pragma mark -

#pragma mark -
#pragma mark Private
- (void)prepareViews{
    
}

- (void)showViews{

}

#pragma mark -


@end
