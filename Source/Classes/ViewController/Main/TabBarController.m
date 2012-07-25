//
//  TabBarController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "ViewController.h"

#import "MainController.h"
#import "UIImage+ScaledImage.h"
#import "PasswordViewController.h"

#import "Constants.h"

@interface TabBarController (Private)
- (void)checkPassword;
@end

@implementation TabBarController

#pragma mark -
#pragma mark Initializate 

- (void)awakeFromNib {
    [self loadTabs];
}

- (void)loadTabs {
	
	NSMutableArray *dic = [MainController loadPlist:@"Tabbar"];
	NSMutableArray *controllers = [[[NSMutableArray alloc] init] autorelease];
	
	int count = 0;
	for (NSDictionary *d in dic) {
		if ([[d objectForKey:@"active"] boolValue])
			count++;
	}
	
	int c = 0;
	for (int i = 0; i < [dic count]; i++) {
		NSDictionary *item = [dic objectAtIndex:i];
		
		NSString *itemName = [item objectForKey:@"name"];
		NSString *itemImage = [item objectForKey:@"icon"];
		NSString *itemController = [NSString stringWithFormat:@"%@_%@", [item objectForKey:@"controller"], DEVICE_NAME];
		
		if (![[item objectForKey:@"active"] boolValue])
			continue;
		
		BOOL itemNavigation = [[item objectForKey:@"navigation"] boolValue];
		BOOL itemNavigationHide = [[item objectForKey:@"navigation_hide"] boolValue];
		
		if (c > 3 && count > 5) {
			itemName = @"tabbar_more";
			itemImage = @"tabbar_more.png";
			itemController = [NSString stringWithFormat:@"MoreViewController_%@", DEVICE_NAME];
			
		}
		
		ViewController *controller = [(ViewController *)[[NSClassFromString(itemController) alloc] initWithNibName:itemController bundle:[NSBundle mainBundle]] autorelease];
		controller.tabBarItem.image = [UIImage imageNamed:itemImage];
		controller.tabBarItem.title = NSLocalizedString(itemName, @"");
		controller.index = i;
		
		if (controller) {
			if (itemNavigation) {
				NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:controller];
				[navigationController setNavigationBarHidden:itemNavigationHide];
				[navigationController setDelegate:self];
				
				UIBarButtonItem *backBarButtonItem = [[[UIBarButtonItem alloc] init] autorelease];
				backBarButtonItem.title = NSLocalizedString(itemName, @"");
				controller.navigationItem.backBarButtonItem = backBarButtonItem;
				[controllers addObject:navigationController];
			}
			else {
				[controllers addObject:controller];
			}
		}
		
		if (c > 3 && count > 5)
			break;
		
		c++;
	}
	
	if ([controllers count]) {
		self.viewControllers = controllers;
	}
	
	self.selectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tabbar_selected"] intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_UPDATE object:self];
}

- (void)setSelectedViewController:(UIViewController *)_selectedViewController{
    [super setSelectedViewController:_selectedViewController];
    [self checkPassword];
}

- (void)checkPassword{
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    
    if ((passwordType == 1 && self.selectedIndex == 0) || passwordType == 2) {
        PasswordViewController *passwordController = [MainController getViewController:@"PasswordViewController"];
        passwordController.editType = PasswordEditTypeCheck;
        [[RootViewController shared] presentModalViewController:passwordController animated:NO];
    }
}

@end
