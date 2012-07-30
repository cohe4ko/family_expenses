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
- (void)initPickerView;
- (void)notificationPost;
@end

@implementation PickerPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        initMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
        
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

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)_pickerView{
    return 3;
}

- (NSString *)pickerView:(ALPickerView *)_pickerView textForRow:(NSInteger)row{
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

- (BOOL)pickerView:(ALPickerView *)_pickerView selectionStateForRow:(NSInteger)row{
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    return passwordType == row;
}

// Inform the delegate that a row got selected, if row = -1 all rows are selected
- (void)pickerView:(ALPickerView *)_pickerView didCheckRow:(NSInteger)row{
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"settings_password_type"];
    [pickerView reloadAllComponents];
}
// Inform the delegate that a row got deselected, if row = -1 all rows are deselected
- (void)pickerView:(ALPickerView *)_pickerView didUncheckRow:(NSInteger)row{
    [pickerView reloadAllComponents];
}

#pragma mark -
#pragma mark Make
- (void)makeLocale{
    labelHeader.text = NSLocalizedString(@"settings_password_picker_header", @"");
}

- (void)makeItems{
    [self initPickerView];
    pickerView.allOptionTitle = nil;
    pickerView.delegate = self;
    CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(15.0f, 11.0f, pickerView.frame.size.width - 30.0f, pickerView.frame.size.height - 22.0f)];
	[mask setCornerRadius:5.0f];
	[pickerView.layer setMask:mask];
	[mask release];
}

- (void)initPickerView{
    
}

#pragma mark -
#pragma mark Set
- (void)setData{
    
}

#pragma mark -
#pragma mark Action
- (IBAction)actionDone{
	[UIView animateWithDuration:0.2 animations:^{
		[viewOverlay setAlpha:0.0f];
	} completion:^(BOOL finished) {
		[self dismissModalViewControllerAnimated:YES];
        [self performSelector:@selector(notificationPost)
                   withObject:nil
                   afterDelay:0.5];
	}];
}

- (void)notificationPost{
    if (initMode != [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PASSWORD_UPDATE object:nil];
    }
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
    if (labelHeader) {
        [labelHeader release];
        labelHeader = nil;
    }
    if (pickerView) {
        [pickerView release];
        pickerView = nil;
    }
    if (buttonDone) {
        [buttonDone release];
        buttonDone = nil;
    }
    if (viewOverlay) {
        [viewOverlay release];
        viewOverlay = nil;
    }
    
}

- (void)dealloc{
    [self clean];
    [super dealloc];
}

@end
