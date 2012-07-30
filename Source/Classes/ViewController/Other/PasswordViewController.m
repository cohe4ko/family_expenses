//
//  PasswordViewController.m
//  Expenses
//
//  Created by MacBook iAPPLE on 24.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "PasswordViewController.h"
#import "AMAnimationShake.h"

@interface PasswordViewController ()
- (void)makeItems;
- (void)makeLocale;
- (void)prepareViews;
- (void)showViews;
- (void)updateLabel:(UILabel*)label;
- (void)passwordEntered;
- (void)closeView;
- (void)clean;
@end

@implementation PasswordViewController
@synthesize editType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        step = 0;
        code = 0;
        newCode = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self makeItems];
    [self makeLocale];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Make
- (void)makeItems{
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    if (editType == PasswordEditTypeCheck) {
        buttonSave.hidden = YES;
        if(passwordType == 2)
            buttonBarCancel.hidden = YES;
    }else if(editType == PasswordEditTypeAdd) {
        buttonSave.hidden = YES;
        buttonBarCancel.hidden = YES;
    }
    labelCode1.hidden = YES;
    labelCode2.hidden = YES;
    labelCode3.hidden = YES;
    labelCode4.hidden = YES;
    
    labelTopTitle.text = NSLocalizedString(@"app_title", @"");
    [labelTopTitle setTextColor:[UIColor colorWithHexString:@"caa7a7"]];
    [labelTopTitle setFont:[UIFont fontWithName:@"LeckerliOneCTT" size:23]];
    
    [buttonBarCancel setBackgroundImage:[[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
}

- (void)makeLocale{
    switch (editType) {
        case PasswordEditTypeAdd:
            if (step == 0) {
                labelHeader.text = NSLocalizedString(@"password_new_password", @"");
            }else{
                labelHeader.text = NSLocalizedString(@"password_accept_password", @"");
            }
            
            break;
        case PasswordEditTypeCheck:
            labelHeader.text = NSLocalizedString(@"password_enter_password", @"");
            break;
        case PasswordEditTypeReplace:
            if (step == 0) {
                labelHeader.text = NSLocalizedString(@"password_old_password", @"");
            }else {
                labelHeader.text = NSLocalizedString(@"password_new_password", @"");
            }
            
            break;
        default:
            break;
    }
}

#pragma mark -

#pragma mark -
#pragma mark Action
- (IBAction)actionSave:(UIButton*)sender{
    
}

- (IBAction)actionCancel:(UIButton*)sender{
    code = 0;
    labelCode1.hidden = YES;
    labelCode2.hidden = YES;
    labelCode3.hidden = YES;
    labelCode4.hidden = YES;
}

- (IBAction)actionNumberPressed:(UIButton*)sender{
    UILabel *l = nil;
    if (labelCode1.hidden) {
        l = labelCode1;
    }else if(labelCode2.hidden) {
        l = labelCode2;
    }else if(labelCode3.hidden) {
        l = labelCode3;
    }else if(labelCode4.hidden) {
        l = labelCode4;
        [self performSelector:@selector(passwordEntered) withObject:nil afterDelay:0.35];
    }
    if (l) {
        l.text = [NSString stringWithFormat:@"%d",sender.tag%10];
        l.hidden = NO;
       [self performSelector:@selector(updateLabel:) withObject:l afterDelay:0.25];
    }

}

- (IBAction)actionBarCancel:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PASSWORD_CANCELED object:nil];
    [self closeView];
}

#pragma mark -

#pragma mark -
#pragma mark Private
- (void)prepareViews{
    
}

- (void)showViews{

}

- (void)updateLabel:(UILabel*)label{
    code = 10*code+[label.text intValue];
    label.text = @"●";
}

- (void)passwordEntered{
    if (editType == PasswordEditTypeAdd) {
        if (step == 0) {
            newCode = code;
            labelHeader.text = NSLocalizedString(@"password_accept_password", @"");
            [self actionCancel:buttonCancel];
            step = 1;
            notCorEntCount = 0;
        }else if(step == 1) {
            if (code == newCode) {
                [[NSUserDefaults standardUserDefaults] setInteger:code forKey:@"user_password"];
                [self closeView];
            }else {
                AMAnimationShake *shake = [[[AMAnimationShake alloc] init] autorelease];
                shake.object = contentView;
                [shake shakeXWithOffset:12.0 breakFactor:0.9f duration:0.5f maxShakes:5];
                [self actionCancel:nil];
                notCorEntCount++;
                if (notCorEntCount>2) {
                    step = 0;
                    labelHeader.text = NSLocalizedString(@"password_new_password", @"");
                }
            }
            
        }
        
    }else if(editType == PasswordEditTypeCheck) {
        NSInteger cCode = [[NSUserDefaults standardUserDefaults] integerForKey:@"user_password"];
        if (cCode == code) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PASSWORD_CORRECT object:nil];
            [self closeView];
        }else {
            AMAnimationShake *shake = [[[AMAnimationShake alloc] init] autorelease];
            shake.object = contentView;
            [shake shakeXWithOffset:12.0 breakFactor:0.9f duration:0.5f maxShakes:5];
            [self actionCancel:nil];
        }
    }else if(editType == PasswordEditTypeReplace) {
        if (step == 0) {
            NSInteger cCode = [[NSUserDefaults standardUserDefaults] integerForKey:@"user_password"];
            if (cCode == code) {
                [self actionCancel:nil];
                step = 1;
                labelHeader.text = labelHeader.text = NSLocalizedString(@"password_new_password", @"");
            }else {
                [[NSUserDefaults standardUserDefaults] setInteger:code forKey:@"user_password"];
                [self closeView];
            }
        }
    }
}


- (void)closeView{
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark -

#pragma mark -
#pragma mark Memory management
- (void)clean{
    if(viewTopShutter){
        [viewTopShutter release];
        viewTopShutter = nil;
    }
    if(viewBottomShutter){
        [viewBottomShutter release];
        viewBottomShutter = nil;
    }
    if(buttonSave){
        [buttonSave release];
        buttonSave = nil;
    }
    if(buttonCancel){
        [buttonCancel release];
        buttonCancel = nil;
    }
    if(labelHeader){
        [labelHeader release];
        labelHeader = nil;
    }
    if(labelCode1){
        [labelCode1 release];
        labelCode1 = nil;
    }
    if(labelCode2){
        [labelCode2 release];
        labelCode2 = nil;
    }
    if(labelCode3){
        [labelCode3 release];
        labelCode3 = nil;
    }
    if(labelCode4){
        [labelCode4 release];
        labelCode4 = nil;
    }
    if (labelTopTitle) {
        [labelTopTitle release];
        labelTopTitle = nil;
    }
    if (buttonBarCancel) {
        [buttonBarCancel release];
        buttonBarCancel = nil;
    }
    if (contentView) {
        [contentView release];
        contentView = nil;
    }
    if (viewTopBar) {
        [viewTopBar release];
        viewTopBar = nil;
    }

}

- (void)viewDidUnload
{
    [self clean];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc{
    [self clean];
    [super dealloc];
}

#pragma mark -


@end
