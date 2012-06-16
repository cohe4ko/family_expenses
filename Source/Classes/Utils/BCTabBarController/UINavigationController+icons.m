//
//  UINavigationController+icons.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "UINavigationController+icons.h"

@implementation UINavigationController (BCTabBarController)

- (NSString *)iconImageName {
	return [[self.viewControllers objectAtIndex:0] iconImageName];
}

@end
