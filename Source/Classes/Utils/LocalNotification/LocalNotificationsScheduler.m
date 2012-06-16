//
//  LocalNotificationsScheduler.m
//  Planny
//
//  Created by Vinogradov Sergey on 19.10.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "LocalNotificationsScheduler.h"

static LocalNotificationsScheduler *_instance;

@implementation LocalNotificationsScheduler

@synthesize badgeCount = _badgeCount;

+ (LocalNotificationsScheduler *)sharedInstance {
	@synchronized(self) {
        if (_instance == nil) {
			
			// iOS 4 compatibility check
			Class notificationClass = NSClassFromString(@"UILocalNotification");
			
			if(notificationClass == nil) {
				_instance = nil;
			}
			else  {				
				_instance = [[super allocWithZone:NULL] init];				
				_instance.badgeCount = 0;
			}
        }
    }
    return _instance;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone {	
   return [[self sharedInstance] retain];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;	
}

- (id)retain {	
    return self;	
}

- (unsigned)retainCount {
    return NSUIntegerMax;
}

- (void)release {
}

- (id)autorelease {
    return self;	
}

- (void)scheduleNotificationOn:(NSDate *)fireDate interval:(NSCalendarUnit)repeatInterval text:(NSString *)alertText action:(NSString *)alertAction sound:(NSString *)soundfileName launchImage:(NSString *)launchImage andInfo:(NSDictionary *)userInfo {
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
	localNotification.fireDate = fireDate;
	localNotification.repeatInterval = repeatInterval;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];	
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;	
	localNotification.soundName = (soundfileName == nil) ? UILocalNotificationDefaultSoundName : soundfileName;
	localNotification.alertLaunchImage = launchImage;
     //localNotification.applicationIconBadgeNumber = ++self.badgeCount;			
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

- (void)clearBadgeCount {
	self.badgeCount = 0;
	//[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)decreaseBadgeCountBy:(int)count {
	self.badgeCount -= count;
	if(self.badgeCount < 0) 
		self.badgeCount == 0;
	//[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)handleReceivedNotification:(UILocalNotification *)thisNotification {
	//NSLog(@"Received: %@",[thisNotification description]);
	//[self decreaseBadgeCountBy:1];
}

@end
