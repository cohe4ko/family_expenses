//
//  PickerCurrencyViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PickerCurrencyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSLocale+Currency.h"

@interface PickerCurrencyViewController ()
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
- (void)selectButtonWithTag:(NSInteger)tag;
- (void)deselectButtonWithTag:(NSInteger)tag;
- (void)deselectAllButtons;
- (void)clear;
- (void)loadData;
@end

@implementation PickerCurrencyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [imageNavigationbarShadow setHidden:YES];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
}

- (void)viewDidAppear:(BOOL)animated {
	[UIView animateWithDuration:0.3 animations:^{
		[overlayView setAlpha:1.0f];
	}];
	[super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self clear];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Make

- (void)makeLocales{
    [doneButton setTitle:NSLocalizedString(@"add_picker_button_done", @"") forState:UIControlStateNormal];
	
	[labelHeader setText:NSLocalizedString(@"settings_currency_picker_title", @"")];
    [buttonNoPoints setTitle:NSLocalizedString(@"settings_currency_picker_nopoint", @"") forState:UIControlStateNormal];
    [buttonOnePoint setTitle:NSLocalizedString(@"settings_currency_picker_onepoint", @"") forState:UIControlStateNormal];
    [buttonTwoPoints setTitle:NSLocalizedString(@"settings_currency_picker_twopoint", @"") forState:UIControlStateNormal];
}

- (void)makeItems{
    [buttonNoPoints setTag:PointsNumberNo];
    [buttonOnePoint setTag:PointsNumberOne];
    [buttonTwoPoints setTag:PointsNumberTwo];
    
    CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(15.0f, 11.0f, pickerView.frame.size.width - 30.0f, pickerView.frame.size.height - 22.0f)];
	[mask setCornerRadius:5.0f];
	[pickerView.layer setMask:mask];
	[mask release];
    
    NSString *countryCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"settings_country_code"];
    for (int i = 0; i < [codesArray count]; i++) {
        NSDictionary *currencyDic = [codesArray objectAtIndex:i];
        if ([[currencyDic objectForKey:@"countryCode"] isEqualToString:countryCode]) {
            [pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }

}

#pragma mark -
#pragma mark Set

- (void)setData{
    selectedButton = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    [self selectButtonWithTag:selectedButton];
}

#pragma mark -
#pragma mark Load

- (void)loadData{
    if (codesArray) {
        [codesArray release];
        codesArray = nil;
    }
    codesArray = [[NSArray alloc] initWithArray:[NSLocale supportedCurrencyList]];
    
}

#pragma mark -
#pragma mark UIPickerController dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (codesArray) {
        return [codesArray count];
    }
    return 0;
}

#pragma mark -
#pragma mark UIPickerController delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *currencyDic = [codesArray objectAtIndex:row];
    NSString *country = [currencyDic objectForKey:@"country"];
    NSString *currency = [currencyDic objectForKey:@"currency"];
    return [NSString stringWithFormat:@"%@ %@",country,currency];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDone:(id)sender {
	[UIView animateWithDuration:0.2 animations:^{
		[overlayView setAlpha:0.0f];
	} completion:^(BOOL finished) {
		[self dismissModalViewControllerAnimated:YES];
	}];
}

- (IBAction)actionPointsChanged:(UIButton*)sender{
    if (selectedButton != sender.tag) {
        [self deselectButtonWithTag:selectedButton];
        selectedButton = sender.tag;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedButton forKey:@"settings_currency_points"];
        [self selectButtonWithTag:selectedButton];
        isShouldUpdate = YES;
    }
}

#pragma mark -
#pragma mark Private

- (void)selectButtonWithTag:(NSInteger)tag{
}
- (void)deselectButtonWithTag:(NSInteger)tag{
    
}
- (void)deselectAllButtons{
    for (int i = 100; i<104; i++) {
        [self deselectButtonWithTag:i];
    }
}

- (void)clear{
    if (overlayView) {
        [overlayView release];
        overlayView = nil;
    }
    if (pickerView) {
        [pickerView release];
        pickerView = nil;
    }
    if (labelHeader) {
        [labelHeader release];
        labelHeader = nil;
    }
    if (buttonNoPoints) {
        [buttonNoPoints release];
        buttonNoPoints = nil;
    }
    if (buttonOnePoint) {
        [buttonOnePoint release];
        buttonOnePoint = nil;
    }
    if (buttonTwoPoints) {
        [buttonTwoPoints release];
        buttonTwoPoints = nil;
    }
    if (doneButton) {
        [doneButton release];
        doneButton = nil;
    }
    if (codesArray) {
        [codesArray release];
        codesArray = nil;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc{
    [self clear];
    [super dealloc];
}


@end
