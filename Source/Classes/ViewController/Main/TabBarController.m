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
- (BOOL)checkPassword:(NSInteger)index;
- (void)clean;
@end

@implementation TabBarController

#pragma mark -
#pragma mark Initializate 

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionPasswordChecked)
                                                 name:NOTIFICATION_PASSWORD_CORRECT
                                               object:nil];
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
	    
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tabbar_selected"] intValue];
    
    if (passwordType == 1 && index == 0) {
        self.selectedIndex = 1;
    }else {
        self.selectedIndex = index;
    }
    
      
 
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_UPDATE object:self];
}

- (void)setSelectedViewController:(UIViewController *)_selectedViewController{
    shouldOpenIndexAfterPassword = [self.viewControllers indexOfObject:_selectedViewController];
    if (![self checkPassword:shouldOpenIndexAfterPassword]) {
        [super setSelectedViewController:_selectedViewController];
    }
}

- (BOOL)checkPassword:(NSInteger)index{
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    
    if ((passwordType == 1 && index == 0) || passwordType == 2) {
        UIViewController *currentModalController = [RootViewController shared].modalViewController;
        if (!currentModalController) {
            PasswordViewController *passwordController = [MainController getViewController:@"PasswordViewController"];
            passwordController.editType = PasswordEditTypeCheck;
            [[RootViewController shared] presentModalViewController:passwordController animated:NO];
        }

        return YES;
    }else {
        UIViewController *currentModalController = [RootViewController shared].modalViewController;
        if (currentModalController) {
            [[RootViewController shared] dismissModalViewControllerAnimated:YES];
        }
        return NO;
    }
    
}

#pragma mark -
#pragma mark Password
- (void)actionPasswordChecked{
    [super setSelectedViewController:[self.viewControllers objectAtIndex:shouldOpenIndexAfterPassword]];
}


#pragma mark -
#pragma mark MemoryManagement

- (void)clean{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload{
    [self clean];
    [super viewDidUnload];
}

- (void)dealloc{
    [self clean];
    [super dealloc];
}



@end
