//
//  PasswordViewController_iPhone.m
//  Expenses
//
//  Created by MacBook iAPPLE on 24.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PasswordViewController_iPhone.h"

@interface PasswordViewController_iPhone ()

@end

@implementation PasswordViewController_iPhone

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
#pragma mark Action

- (void)closeView{
    [UIView animateWithDuration:0.5f
                     animations:^{
                        viewTopShutter.frame = CGRectMake(0, -viewTopShutter.frame.size.height, viewTopShutter.frame.size.width, viewTopShutter.frame.size.height);
                        viewBottomShutter.frame = CGRectMake(0, 460, viewBottomShutter.frame.size.width, viewBottomShutter.frame.size.height);
                        viewTopBar.frame = CGRectMake(0, -viewTopBar.frame.size.height, viewTopBar.frame.size.width, viewTopBar.frame.size.height);
                        contentView.frame = CGRectMake(0, 460, contentView.frame.size.width, contentView.frame.size.height); 
                     }
                     completion:^(BOOL finished){
                         self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                         [self dismissModalViewControllerAnimated:YES];
                     }];
}

@end
