//
//  BCTabBarController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "BCTabBar.h"

@class BCTabBarView;

@interface BCTabBarController : UIViewController <BCTabBarDelegate, UINavigationControllerDelegate> {
	int selectedIndex;
	NSArray *viewControllers;
	UIViewController *selectedViewController;
	BCTabBar *tabBar;
	BCTabBarView *tabBarView;
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) int selectedIndex;
@property (nonatomic, readonly) BOOL visible;

@end
