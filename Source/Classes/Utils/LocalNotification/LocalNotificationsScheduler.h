//
//  LocalNotificationsScheduler.h
//  Planny
//
//  Created by Vinogradov Sergey on 19.10.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationsScheduler : NSObject {
	int _badgeCount;
}

@property int badgeCount;

+ (LocalNotificationsScheduler *)sharedInstance;

- (void)scheduleNotificationOn:(NSDate *)fireDate interval:(NSCalendarUnit)repeatInterval text:(NSString *)alertText action:(NSString *)alertAction sound:(NSString *)soundfileName launchImage:(NSString *)launchImage andInfo:(NSDictionary *)userInfo;
- (void)handleReceivedNotification:(UILocalNotification *)thisNotification;
- (void)decreaseBadgeCountBy:(int)count;
- (void)clearBadgeCount;

@end
