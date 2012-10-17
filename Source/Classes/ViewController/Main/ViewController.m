//
//  ViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 24.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Private)
- (void)setLogo;
@end

@implementation ViewController

@synthesize index;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	connectionStatus = [[AppDelegate shared] checkConnection];
	
	// Register notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"background_navigationbar.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
    }
	
	// Add navigation bar shadow
	imageNavigationbarShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"background_navigationbar_shadow.png"] stretchableImageWithLeftCapWidth:160.0f topCapHeight:0.0f]];
	[imageNavigationbarShadow setFrame:CGRectMake(0.00f, 0.00f, imageNavigationbarShadow.frame.size.width, imageNavigationbarShadow.frame.size.height)];
	[imageNavigationbarShadow setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:imageNavigationbarShadow];
	
	// Add tabbar shadow
	imageTabbarShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"background_tabbar_shadow.png"] stretchableImageWithLeftCapWidth:160.0f topCapHeight:0.0f]];
	[imageTabbarShadow setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:imageTabbarShadow];
	
	// Set logo
	[self setLogo];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Change rect shadows
	[imageTabbarShadow setFrame:CGRectMake(0.00f, self.view.frame.size.height - imageTabbarShadow.frame.size.height, imageTabbarShadow.frame.size.width, imageTabbarShadow.frame.size.height)];
	
	[self.view bringSubviewToFront:imageNavigationbarShadow];
	[self.view bringSubviewToFront:imageTabbarShadow];
}

#pragma mark -
#pragma mark Network notifications

- (void)updateConnection:(BOOL)connection {
	if (connection && !connectionStatus) {
		connectionStatus = connection;
		[labelMessageConnection setHidden:NO];
		[labelMessageConnection setText:@""];
		//if ([self respondsToSelector:@selector(loadData)])
		//	[self performSelector:@selector(loadData)];
	}
	
	if (!connection) {
		if (![RootViewController shared].tabBarController.selectedIndex)
			[(UINavigationController *)[AppDelegate shared].tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
	}
}

- (void)reachabilityChanged:(NSNotification *)note {
	[self updateConnection:[[AppDelegate shared] checkConnection]];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardDidShow:(CGFloat)height {
	
}

- (void)keyboardDidHide:(CGFloat)height {
	
}

- (void)keyboardWillShow:(NSNotification *)n {
	
	CGRect _keyboardFrame;
	CGFloat _keyboardHeight;
	
	if (&UIKeyboardFrameEndUserInfoKey != nil) {
        [[n.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardFrame];
		_keyboardHeight = _keyboardFrame.size.height;
	} 
	else {
        [[n.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&_keyboardFrame];
        _keyboardHeight = _keyboardFrame.size.height;
    }
	
	CGFloat size = _keyboardHeight;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self keyboardDidShow:size];
	[UIView commitAnimations];
	
	keyboardIsShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)n {
	if(!keyboardIsShown)
		return;
	
	CGRect _keyboardFrame;
	CGFloat _keyboardHeight;
	
	if (&UIKeyboardFrameEndUserInfoKey != nil) {
        [[n.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardFrame];
		_keyboardHeight = _keyboardFrame.size.height;
	} 
	else {
        [[n.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&_keyboardFrame];
        _keyboardHeight = _keyboardFrame.size.height;
    }
	
	CGFloat size = -_keyboardHeight;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self keyboardDidHide:size];
	[UIView commitAnimations];
	
	keyboardIsShown = NO;
}

#pragma mark -
#pragma mark Setters

- (void)setLogo {
	[self setTitle:NSLocalizedString(@"app_title", @"")];
	
}

- (void)setTabbarShadowHide {
	[imageTabbarShadow setHidden:TRUE];
}

- (void)setTitle:(NSString *)theTitle {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setFont:[UIFont fontWithName:@"LeckerliOneCTT" size:23]];
	[label setTextColor:[UIColor colorWithHexString:@"caa7a7"]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setShadowColor:[[[UIColor alloc] initWithRed:0.0 green:0 blue:0 alpha:0.4] autorelease]];
	[label setShadowOffset:CGSizeMake(0.00f, -1.00f)];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setText:theTitle];
	[label sizeToFit];
	self.navigationItem.titleView = label;
	[label release];
}

- (void)setButtonLeft:(NSString *)theTitle withSelector:(SEL)selector {
	AMButton *button = [[AMButton alloc] init];
	[button setTitle:theTitle forState:UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

- (void)setButtonLeftWithImage:(UIImage *)theImage withSelector:(SEL)selector {
	[self setButtonLeftWithImage:theImage withSelector:selector withType:AMButtonTypeDefault];
}

- (void)setButtonLeftWithImage:(UIImage *)theImage withSelector:(SEL)selector withType:(AMButtonType)type {
	AMButton *button = [[AMButton alloc] init];
	[button setTypeButton:type];
	[button setImage:theImage forState:UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

- (void)setButtonRight:(NSString *)theTitle withSelector:(SEL)selector {
	[self setButtonRight:theTitle withSelector:selector withType:AMButtonTypeDefault];
}

- (void)setButtonRight:(NSString *)theTitle withSelector:(SEL)selector withType:(AMButtonType)type {
	AMButton *button = [[AMButton alloc] init];
	[button setTypeButton:type];
	[button setTitle:theTitle forState:UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

- (void)setButtonRightWithImage:(UIImage *)theImage withSelector:(SEL)selector {
	[self setButtonRightWithImage:theImage withSelector:selector withType:AMButtonTypeDefault];
}

- (void)setButtonRightWithImage:(UIImage *)theImage withSelector:(SEL)selector withType:(AMButtonType)type {
	AMButton *button = [[AMButton alloc] init];
	[button setTypeButton:type];
	[button setImage:theImage forState:UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

- (void)setButtonBack {
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

- (void)setButtonBack:(NSString *)theTitle {
	AMButtonBack *button = [[AMButtonBack alloc] init];
	[button setTitle:theTitle forState:UIControlStateNormal];
	[button addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	[button release];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionBack {
	[self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark Memory manangment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end