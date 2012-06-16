//
//  BCTabBarController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "UIViewController+iconImage.h"
#import "BCTabBarView.h"
#import "TabBarController.h"
#import "MainController.h"

#define kUINavigationControllerPushPopAnimationDuration     0.35

@interface BCTabBarController ()

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

- (void)loadTabs;
- (void)loadTabsItems;

@end

@implementation BCTabBarController

@synthesize viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, selectedIndex, visible;

#pragma mark -
#pragma mark Initializate

- (void)loadView {
	
	self.selectedIndex = 0;
	
	self.tabBarView = [[[BCTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view = self.tabBarView;

	self.tabBar = [[[BCTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 55.00f, self.view.bounds.size.width, 55.00f)] autorelease];
	self.tabBar.delegate = self;
	
	self.tabBarView.backgroundColor = [UIColor clearColor];
	self.tabBarView.tabBar = self.tabBar;
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    if (!self.childViewControllers) {
        [self.selectedViewController view];
        [self.selectedViewController viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}

#pragma mark -
#pragma mark Load

- (void)loadTabs {
	
}

- (void)loadTabsItems {
	if (!self.viewControllers.count)
		return;
	
	NSMutableArray *dic = [MainController loadPlist:@"Tabbar"];
	
	int count = 0;
	for (NSDictionary *d in dic) {
		if ([[d objectForKey:@"active"] boolValue])
			count++;
	}
	
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
	int i = 0;
	
	for (UIViewController *vc in self.viewControllers) {
		NSDictionary *vitem = [dic objectAtIndex:i];
		NSString *name = [[vc tabBarItem] title];
		NSString *imageName = (i > 3 && count > 5) ? @"tabbar_more.png" : [vitem objectForKey:@"icon"];
		BCTab *tab = [[[BCTab alloc] initWithIconImageName:imageName andName:name] autorelease];
		tab.isCenter = (i && i < self.viewControllers.count - 1);
		[tabs addObject:tab];
		i++;
	}
	self.tabBar.tabs = tabs;
	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:selectedIndex] animated:NO];
}

#pragma mark -
#pragma mark Methods

- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	
	[[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"tabbar_selected"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	UIViewController *vc = [self.viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	}
	else {
		self.selectedViewController = vc;
	}
}

#pragma mark -
#pragma mark Setters

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		selectedViewController = vc;
        if (!self.childViewControllers && visible) {
			[oldVC viewWillDisappear:NO];
            [selectedViewController view];
			[selectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
        if (!self.childViewControllers && visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
	}
}

- (void)setSelectedIndex:(int)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex) {
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
	}
}


- (int)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		[viewControllers release];
		viewControllers = [array retain];	
		if (viewControllers != nil) {
			[self loadTabsItems];
		}
	}
	self.selectedIndex = 0;
}

#pragma mark -
#pragma mark Interface orientation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)hideTabBar:(BOOL)animated isPush:(BOOL)isPush {
    if (tabBar.isInvisible) {
        return;
    }
    tabBar.isInvisible = YES;
	CGRect f = self.tabBarView.contentView.frame;
    f.size.height = self.tabBarView.bounds.size.height;
	self.tabBarView.contentView.frame = f;
    
    NSTimeInterval duration = 0.0;
    if (animated) {
        duration = kUINavigationControllerPushPopAnimationDuration;
    }
    CGFloat magicNumber = - 1.0;
    if (!isPush) {
        magicNumber = 2.0;
    }
    self.tabBar.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:duration
                     animations:^{self.tabBar.transform = CGAffineTransformMakeTranslation(self.tabBar.bounds.size.width * magicNumber, 0.0);}
                     completion:^(BOOL finished){
                         self.tabBar.hidden = YES;
                         self.tabBar.transform = CGAffineTransformIdentity;
                     }];
    [self.tabBarView setNeedsLayout];
}

- (void)showTabBar:(BOOL)animated isPush:(BOOL)isPush {
    if (!tabBar.isInvisible) {
        return;
    }
    
    NSTimeInterval duration = 0.0;
    if (animated) {
        duration = kUINavigationControllerPushPopAnimationDuration;
    }
    CGFloat magicNumber = 2.0;
    if (!isPush) {
        magicNumber = - 1.0;
    }
    self.tabBar.transform = CGAffineTransformMakeTranslation(self.tabBar.bounds.size.width * magicNumber, 0.0);
    self.tabBar.hidden = NO;
    [UIView animateWithDuration:duration animations:^{
		self.tabBar.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished){
		tabBar.isInvisible = NO;
		[self.tabBarView setNeedsLayout];
	}];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isPush = YES;
    UINavigationItem *newTopItem = navigationController.topViewController.navigationItem;
    if ([newTopItem isEqual:navigationController.navigationBar.topItem] && !animated) {
        return;
    } 
	else {
        for (UINavigationItem *item in navigationController.navigationBar.items) {
            if ([item isEqual:newTopItem]) {
                isPush = NO;
                break;
            }
        }
    }
    if (viewController.hidesBottomBarWhenPushed) {
        [self hideTabBar:animated isPush:isPush];
    } 
	else {
        [self showTabBar:animated isPush:isPush];
    }
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	self.tabBar = nil;
	self.selectedTab = nil;
}

- (void)dealloc {
	self.viewControllers = nil;
	self.tabBar = nil;
	self.selectedTab = nil;
	self.tabBarView = nil;
	[super dealloc];
}

@end
