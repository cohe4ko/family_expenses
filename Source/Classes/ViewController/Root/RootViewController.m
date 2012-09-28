//
//  MainViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 06.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "RootViewController.h"
#import "TabBarController.h"
#import "AlertViewController.h"

#import "LoadingView.h"
#import "AlertViewNetwork.h"

#import "MainController.h"
#import "CategoriesController.h"
#import "TransactionsController.h"

#import "UIImage+ScaledImage.h"
#import "NSTimer+Pause.h"

#import "DataManager.h"
#import "Constants.h"

#import "SettingsController.h"

#import "TutorialView.h"

#import "File.h"

@interface RootViewController(Private)
- (void)runFirstUpload;
- (void)runAuth;
- (void)runComplete;
- (void)runCheckUpdate;
- (void)actionLogin:(BOOL)yesOrNo;
- (void)showTutorial;
@end

@implementation RootViewController

@synthesize viewLoading, viewConnection, viewSplash, labelWarningTitle, labelWarningSubtitle;
@synthesize master, isOrientationPortrait;

#pragma mark -
#pragma mark Share object 

static RootViewController *rootViewController = NULL;

+ (RootViewController *)shared {
    if (!rootViewController) {
        rootViewController = [[RootViewController alloc] init];
    }
    return rootViewController;
}

- (id)init {
    if (!rootViewController) {
        rootViewController = [super init];
    }
    return rootViewController;
}

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
	[super viewDidLoad];
	
	rootViewController = self;
}

#pragma mark -
#pragma mark Run

- (void)run {
	
	// Load categories
	[CategoriesController loadCategories];
	
	if (CREATE_TMP_TRANSACTIONS) {
		BOOL isCreate = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_transactions_temp"];
		if (!isCreate) {
			[TransactionsController createTmpTransactions];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_transactions_temp"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	
	[self runComplete];
}
		 
- (void)runComplete {
	[self hideSplash];
    [self performSelector:@selector(showTutorial) withObject:nil afterDelay:1.0];
}

#pragma mark -
#pragma mark Actions

#pragma mark -
#pragma mark MainController delegate

- (void)requestSucceeded:(id)result forConnection:(NSString *)connectionIdentifier {
}

- (void)requestFailed:(NSError *)error forConnection:(NSString *)connectionIdentifier {
	NSLog(@"error - %@", error);
}

#pragma mark -
#pragma mark Action


#pragma mark -
#pragma mark Alert

- (void)showAlert:(NSString *)title message:(NSString *)message {
	[self showAlert:title message:message target:nil selector:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message target:(id)target selector:(SEL)selector {
	[alertController setTarget:target];
	[alertController setSelector:selector];
	[alertController setTitle:title];
	[alertController setMessage:message];
	[alertController show];
	
	if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark -
#pragma mark Loading

- (void)showLoading:(BOOL)show {
	[self showLoading:show message:NSLocalizedString(@"loading", @"Loading")];
}

- (void)showLoading:(BOOL)show message:(NSString *)message {
	
	if (self.viewLoading == nil) {
		self.viewLoading = [[[LoadingView alloc] initWithFrame:self.master.tabBarController.view.frame] autorelease];
	}
	[self.viewLoading setMessage:message];
	[self.viewLoading setHidden:!show];
	[self.viewLoading changeRect];
	[self.viewLoading removeFromSuperview];
	
	if (master.tabBarController.modalViewController) {
		[master.tabBarController.modalViewController.view addSubview:self.viewLoading];
		[master.tabBarController.modalViewController.view bringSubviewToFront:self.viewLoading];
	}
	else {
		[self.view addSubview:self.viewLoading];
		[self.view bringSubviewToFront:self.viewLoading];
	}
	
	if (show) {
		if (![[UIApplication sharedApplication] isIgnoringInteractionEvents])
			[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
	else {
		if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

#pragma mark -
#pragma mark Splash methods

/*
 * Метод отображения заставки
 */
- (void)showSplash {
	isShowSplash = TRUE;
	[self.view.superview addSubview:viewSplash];
}

/*
 * Метод скрытия заставки
 */
- (void)hideSplash {
	isShowSplash = FALSE;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5f];
	[viewSplash setFrame:CGRectMake(0.00f, viewSplash.frame.size.height, viewSplash.frame.size.width, viewSplash.frame.size.height)];
	[UIView commitAnimations];
	
	[master.tabBarController loadTabs];
	[master.tabBarController.view setFrame:CGRectMake(0.00f, 20.00f, 320.00f, 460.00f)];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)splashMessage:(NSString *)text {
	labelSplash.text = text;
	[labelSplash setHidden:FALSE];
	[indicatorSplash startAnimating];
}

#pragma mark -
#pragma mark Show tutorial

- (void)showTutorial{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialShouldShow"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialShouldShow"]) {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            UIImage *image = [UIImage imageNamed:@"background.png"];
            [images addObject:image];
        }
        TutorialView *tutorialView = [[TutorialView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [tutorialView setImages:images];
        [tutorialView onClose:^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tutorialShouldShow"];
        }];
        if (master.tabBarController.modalViewController) {
            [tutorialView showOnView:master.tabBarController.modalViewController.view animated:YES];
        }else{
            [tutorialView showOnView:master.tabBarController.view animated:YES];
        }
        [tutorialView release];
    }
}

#pragma mark -
#pragma mark UIAlertView

static TSAlertView *sAlert = nil;

- (void)alert:(NSString *)title message:(NSString *)message {
	[self alert:title message:message target:nil selector:nil];
}

- (void)alert:(NSString *)title message:(NSString *)message target:(id)target selector:(SEL)selector {
	selectorAlert = selector;
    targetAlert = [target retain];
	if (sAlert)
		return;
    sAlert = [[TSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"close", @"Close") otherButtonTitles:nil];
	[sAlert setBackgroundImage:[UIImage imageNamed:@"alert_background_front.png"]];
	[sAlert setButtonLayout:TSAlertViewButtonLayoutNormal];
    [sAlert show];
    [sAlert release];
}

- (void)alertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	sAlert = nil;
	if (targetAlert && selectorAlert && [targetAlert respondsToSelector:selectorAlert])
		[targetAlert performSelector:selectorAlert];
}

#pragma mark -
#pragma mark Fixed UI controllers

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	isOrientationPortrait = !((toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) || (toInterfaceOrientation == UIDeviceOrientationLandscapeRight));
	imageViewSplash.image = [UIImage scaledImageNamed:[NSString stringWithFormat:@"background_%@.png", (self.isOrientationPortrait) ? @"portrait" : @"landscape"]];
	[self.viewLoading redraw:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}

- (void)dealloc {
	[master release];
	[viewLoading release];
	[viewConnection release];
	[connectionAuth release];
	[connectionHistory release];
	[connectionProducts release];
	[connectionCheckUpdate release];
	[indicatorSplash release];
	[labelSplash release];
   	[super dealloc];
}

@end