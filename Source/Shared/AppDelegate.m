//
//  AppDelegate.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "MainController.h"
#import "AddViewController.h"

#import "NSTimer+Pause.h"

#import "Model.h"

#import "Constants.h"
#import "iRate.h"


@interface AppDelegate (Private)
- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;
- (void)initializeUserDefaults;
-(void)iRateInit;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize connectionStatus, internetConnectionStatus, remoteHostStatus;
@synthesize rootViewController;
@synthesize pushData;

#pragma mark -
#pragma mark Shared object

static AppDelegate *app = NULL;

+ (AppDelegate *)shared {
    if (!app) {
        app = [[AppDelegate alloc] init];
    }
    return app;
}

#pragma mark -
#pragma mark Initializate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
		pushData = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] retain];
	
	app = self;
	
    //clear password session
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password_session"];
    
    [self iRateInit];
    
	// Setup TestFlight
	[TestFlight takeOff:@"9027be7eee7b774169b20eb1dab3e276_NTQxMzEyMDEyLTAxLTE2IDA3OjMwOjAxLjk1MzgzMw"];
	// Set status bar style
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	// Add registration for remote notifications
	[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	// Clear application badge when app launches
	application.applicationIconBadgeNumber = 0;
	
	// Init DB
	[Model initDB];
	
	// Initialize user defaults
	[self initializeUserDefaults];
	
	// Network statuses
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	
	hostReach = [[Reachability reachabilityWithHostName:HOST] retain];
	[hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
	
	// Init rootviewcontroller
	if (!self.rootViewController){
		RootViewController *controller = [MainController getViewController:@"RootViewController"];
		controller.master = self;
		self.rootViewController = [controller retain];
		[controller release];
	}
	
	// Start timer for check connection
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(run:) userInfo:nil repeats:YES];
	
	//UINavigationController *navController = [[[UINavigationController alloc] init] autorelease];
	//[navController setNavigationBarHidden:YES];
	//[navController pushViewController:self.tabBarController animated:NO];
	//self.window.rootViewController = navController;
	
	[self.window addSubview:self.tabBarController.view];
	
	// Add rootviewcontroller to tabbar controller
	[self.tabBarController.view addSubview:self.rootViewController.view];
	
	// Show splash
	[self.rootViewController showSplash];
	[self.rootViewController splashMessage:NSLocalizedString(@"loading_splash", @"")];
	
    [self.window makeKeyAndVisible];
	
	connectionContact = [NSString string];
	connectionHistory = [NSString string];
	
	return YES;
}

#pragma mark -
#pragma mark iRate
-(void)iRateInit{
#warning appStore id should be set
    [iRate sharedInstance].appStoreID = 536550435; 
    
    [iRate sharedInstance].applicationName = NSLocalizedString(@"app_title", @"");
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"irate_message_title",@"");
    [iRate sharedInstance].rateButtonLabel = NSLocalizedString(@"irate_rate_button_title", @"");
    [iRate sharedInstance].cancelButtonLabel = NSLocalizedString(@"irate_cancel_button_title", @"");
    [iRate sharedInstance].remindButtonLabel = NSLocalizedString(@"irate_remind_button_title", @"");
    [iRate sharedInstance].daysUntilPrompt = 2;
    [iRate sharedInstance].usesUntilPrompt = 3;
    [iRate sharedInstance].remindPeriod = 1;
}

#pragma mark -

- (void)run:(NSTimer *)timer {
	
	[rootViewController run];
	[timer invalidate];
	timer = nil;
	return;
	
	[timer pause];
	if ([self checkConnection]) {
		[timer invalidate];
		timer = nil;
		
		[rootViewController run];
	}
	else {
		[timer resume];
	}
}

#pragma mark -
#pragma mark Initializate user defaults

- (void)initializeUserDefaults {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:SortDate], @"sort_transactions",
                         [NSNumber numberWithInt:GroupInfin],@"group_transactions",
                         [NSNumber numberWithInt:GroupInfin],@"graph_group_transactions",
						 [NSNumber numberWithBool:NO], @"is_transactions_temp",
                         [NSNumber numberWithInt:1], @"settings_currency_points",
                         [NSNumber numberWithInt:25],@"settings_currency_index",
                         [NSNumber numberWithInt:0],@"settings_password_type",
                         [NSNumber numberWithInt:GroupInfin],@"report_group",
                         [NSNumber numberWithInt:2],@"tabbar_selected",
                         [NSNumber numberWithInt:IntervalTypeAll],@"interval_selected",
						 nil];
	
    for (id key in dic) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:key] forKey:key];
        }
    }
}

#pragma mark -
#pragma mark Network connection

- (void)reachabilityChanged:(NSNotification *)note {
	
	Reachability *curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:
			NSLog(@"NotReachable");
			connectionStatus = NO;
            break;
        case ReachableViaWWAN:
			NSLog(@"ReachableViaWWAN");
        case ReachableViaWiFi:
			NSLog(@"ReachableViaWiFi");
			connectionStatus = YES;
            break;
		default:
			break;
    }
}

- (BOOL)checkConnection {
	return connectionStatus;
}

#pragma mark -
#pragma mark Application state

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password_session"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_UPDATE object:self];
    NSInteger selectedIndex = self.tabBarController.selectedIndex;
    NSInteger passwordType = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_password_type"];
    if (passwordType == 1 && selectedIndex != 2) {
        self.tabBarController.selectedIndex = 2;
    }else if(passwordType == 2) {
        self.tabBarController.selectedIndex = selectedIndex;
    }
    
    if (self.tabBarController.selectedIndex == 2) {
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
        if (nav && [nav.topViewController isEqual:[nav.viewControllers objectAtIndex:0]]) {
            AddViewController *addViewController = (AddViewController*)nav.topViewController;
            [addViewController updateTabBar];
        }
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password_session"];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    [_window release];
    [_tabBarController release];
	[pushData release];
    [super dealloc];
}

@end
