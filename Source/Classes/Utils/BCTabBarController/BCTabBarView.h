//
//  BCTabBarView.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

@class BCTabBar;

@interface BCTabBarView : UIView {
	UIView *contentView;
	BCTabBar *tabBar;
}

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) BCTabBar *tabBar;

@end
