//
//  PickerPasswordViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 20.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PickerPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PickerPasswordViewController ()
- (void)makeLocale;
- (void)makeItems;
- (void)setData;
- (void)clean;
@end

@implementation PickerPasswordViewController

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
    [self makeItems];
    [self makeLocale];
    [self setData];
}

- (void)viewDidAppear:(BOOL)animated {
	[UIView animateWithDuration:0.3 animations:^{
		[viewOverlay setAlpha:1.0f];
	}];
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark PickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return NSLocalizedString(@"settings_password_picker_no_password", @"");
            break;
        case 1:
            return NSLocalizedString(@"settings_password_picker_transaction", @"");
            break;
        case 2:
            return NSLocalizedString(@"settings_password_picker_all", @"");
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"settings_password_type"];
    isShouldUpdate = YES;
}

#pragma mark -
#pragma mark Make
- (void)makeLocale{
    labelHeader.text = NSLocalizedString(@"settings_password_picker_header", @"");
}

- (void)makeItems{
    CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(15.0f, 11.0f, pickerView.frame.size.width - 30.0f, pickerView.frame.size.height - 22.0f)];
	[mask setCornerRadius:5.0f];
	[pickerView.layer setMask:mask];
	[mask release];
}

#pragma mark -
#pragma mark Set
- (void)setData{
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    [pickerView selectRow:passwordType inComponent:0 animated:NO];
}

#pragma mark -
#pragma mark Action
- (IBAction)actionDone{
    if (isShouldUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENCY_UPDATE object:nil];
    }
	[UIView animateWithDuration:0.2 animations:^{
		[viewOverlay setAlpha:0.0f];
	} completion:^(BOOL finished) {
		[self dismissModalViewControllerAnimated:YES];
	}];
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload
{
    [self clean];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)clean{
    [labelHeader release];
    [pickerView release];
    [buttonDone release];
    [viewOverlay release];
}

- (void)dealloc{
    [self clean];
    [super dealloc];
}

@end
