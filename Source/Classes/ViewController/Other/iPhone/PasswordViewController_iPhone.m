//
//  PasswordViewController_iPhone.m
//  Expenses
//
//  Created by MacBook iAPPLE on 24.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PasswordViewController_iPhone.h"
#import "AppDelegate.h"
#import "FIAnimationController.h"
#import <QuartzCore/QuartzCore.h>

@interface PasswordViewController_iPhone (Animation)
- (void)animateAppearance;

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
    viewTopShutter.frame = CGRectMake(0, -viewTopShutter.frame.size.height, viewTopShutter.frame.size.width, viewTopShutter.frame.size.height);
    viewBottomShutter.frame = CGRectMake(0, 460, viewBottomShutter.frame.size.width, viewBottomShutter.frame.size.height);
    contentView.frame = CGRectMake(-contentView.frame.size.width, 0, contentView.frame.size.width, contentView.frame.size.height); 
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self animateAppearance];
}

- (void)animateAppearance{
    [UIView animateWithDuration:0.5f animations:^{
        viewTopShutter.frame = CGRectMake(0, 0, viewTopShutter.frame.size.width, viewTopShutter.frame.size.height);
        viewBottomShutter.frame = CGRectMake(0, 247, viewBottomShutter.frame.size.width, viewBottomShutter.frame.size.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.25f
                         animations:^{
                             contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
                         } completion:^(BOOL finished){
                             [[FIAnimationController sharedAnimation:nil] realBounceView:contentView
                                                                                   center:160
                                                                                amplitude:25.0
                                                                                  isXAxis:YES];
                         }];

    }];
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
                         [contentView.layer removeAllAnimations];
                        contentView.frame = CGRectMake(320, 0, contentView.frame.size.width, contentView.frame.size.height); 
                     }
                     completion:^(BOOL finished){
                        [self dismissModalViewControllerAnimated:NO];
                        [RootViewController shared].view.userInteractionEnabled = NO;
                                                      
                                                      
                     }];
}

@end
