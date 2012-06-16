//
//  AppDelegate.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"
#import "TabBarController.h"

#import "TSAlertView.h"

@class RootViewController;
@class History;

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, TSAlertViewDelegate> {
    Reachability *hostReach;
    Reachability *internetReach;
    Reachability *wifiReach;
	
	RootViewController *rootViewController;
	
	NSString *connectionContact;
	NSString *connectionHistory;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TabBarController *tabBarController;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) NSDictionary *pushData;
@property (nonatomic, assign) BOOL connectionStatus;

@property NetworkStatus internetConnectionStatus;
@property NetworkStatus remoteHostStatus;

+ (AppDelegate *)shared;

- (BOOL)checkConnection;

@end
