//
//  NSDate+Utils.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (NSString *)dateFormat:(NSString *)format;

- (NSDate *)dayPrev;
- (NSDate *)dayNext;
- (NSDate *)dayNumber:(int)day;

- (NSDate *)monthPrev;
- (NSDate *)monthNext;
- (NSDate *)monthNumber:(int)month;

+ (NSInteger)ageFromUnixtime:(int)dateOfBirth;
+ (NSInteger)ageFromDate:(NSDate *)dateOfBirth;

+ (int)dateStringToUnixtime:(NSString *)sourceString dateFormat:(NSString *)sourceFormat;
+ (NSString *)dateUnixtimeToString:(int)sourceString dateFormat:(NSString *)destinationFormat;
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat;
+ (NSDate *)dateStringToDate:(NSString *)sourceString dateFormat:(NSString *)sourceFormat;
+ (int)nowUnixtime;
+ (int)nowUnixtimeGMT;
+ (int)todayUnixtime;

- (NSString *)elapsedTime;

+ (NSMutableDictionary *)calculateDates:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSDate *)roundDateToCeilingMinutes:(int)minute;

- (NSInteger)dayOfWeek;
- (NSInteger)dayOfMonth;
- (NSInteger)year;
- (NSInteger)yearDay;

- (NSDate*)monthBegining;
- (NSDate*)monthEnding;
- (NSDate*)dayBegining;
- (NSDate*)dayEnding;
- (NSDate*)weekBegining;
- (NSDate*)weekEnding;

@end
