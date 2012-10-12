//
//  NSDate+Utils.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "NSDate+Utils.h"
#import "NSString+Utils.h"

@implementation NSDate (Utils)

- (NSString *)dateFormat:(NSString *)format {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	return [dateFormatter stringFromDate:self];
}

- (NSDate *)dayPrev {
	return [self dayNumber:-1];
}

- (NSDate *)dayNext {
	return [self dayNumber:1];
}

- (NSDate *)dayNumber:(int)day {
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = day;
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)monthPrev {
	return [self monthNumber:-1];
}

- (NSDate *)monthNext {
	return [self monthNumber:1];
}

- (NSDate *)monthNumber:(int)month {
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.month = month;
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];	
}

- (NSDate*)monthBegining{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:flags fromDate:self];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [calendar dateFromComponents:components];
}

- (NSDate*)monthEnding{
    NSDate *dateBegining = [self monthBegining];
    NSDate *endingDate = [dateBegining monthNext];
    return [endingDate dateByAddingTimeInterval:-1.0];
}

- (NSDate*)dayBegining{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:flags fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [calendar dateFromComponents:components];
}

- (NSDate*)dayEnding{
    NSDate *dayBeginingDate = [self dayBegining];
    NSDate *dayEndingDate = [dayBeginingDate dayNext];
    return [dayEndingDate dateByAddingTimeInterval:-1.0];
}

- (NSDate*)weekBegining{
    NSInteger weekDay = [self dayOfWeek];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:flags fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[calendar dateFromComponents:components] dateByAddingTimeInterval:-weekDay*24*3600];
}

- (NSDate*)weekEnding{
    NSDate *weekBeginingDate = [self weekBegining];
    NSDate *weekEndingDate = [weekBeginingDate dateByAddingTimeInterval:7*24*3600-1.0];
    return weekEndingDate;
}

+ (NSInteger)ageFromUnixtime:(int)dateOfBirth {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateOfBirth];
	return [NSDate ageFromDate:date];
}

+ (NSInteger)ageFromDate:(NSDate *)dateOfBirth {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
	
	if (([dateComponentsNow month] < [dateComponentsBirth month]) || (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
		return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
	} 
	else {
		return [dateComponentsNow year] - [dateComponentsBirth year];
	}
}

/**
 * Форматирование даты из строки в unixtime
 *
 * @param NSString sourceString - исходная дата
 * @param NSString dateFormat - формат исходной даты
 * see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 */
+ (int)dateStringToUnixtime:(NSString *)sourceString dateFormat:(NSString *)sourceFormat; {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat: sourceFormat];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSDate *date = [dateFormatter dateFromString:sourceString];
	return (int)[date timeIntervalSince1970];
}

+ (NSDate *)dateStringToDate:(NSString *)sourceString dateFormat:(NSString *)sourceFormat {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:sourceFormat];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString:sourceString];
	return date;
}

/**
 * Форматирование даты из unixtime в строку
 *
 * @param NSString sourceString - исходная дата в unixtime
 * @param NSString dateFormat - формат конечной даты
 * see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 */
+ (NSString *)dateUnixtimeToString:(int)sourceString dateFormat:(NSString *)destinationFormat {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat: destinationFormat];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:sourceString];        
	return [dateFormatter stringFromDate:date];
}

/**
 * Форматирование даты в другой формат
 *
 * @param NSString sourceString - исходная дата
 * @param NSString sourceFormat - формат исходной даты
 * @param NSString desinationFormat - формат конечной даты
 */
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:sourceFormat];
    NSDate *date = [dateFormatter dateFromString:sourceString];
    [dateFormatter setDateFormat:destinationFormat];
    return [dateFormatter stringFromDate:date];
}

+ (int)nowUnixtime {
	return time(0);
}

+ (int)nowUnixtimeGMT {
	int now = time(0);
	NSInteger offset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:[NSDate date]];
	return now - offset;
}

+ (int)todayUnixtime {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"dd-MM-yyyy"];
	NSString *date = [dateFormat stringFromDate:[[[NSDate alloc] init] autorelease]];
	date = [date stringByAppendingString:@" 00:00:00"];
	return [NSDate dateStringToUnixtime:date dateFormat:@"dd-MM-yyyy hh:mm:ss"];
}

- (NSString *)elapsedTime {
	NSString *result = @"";
	NSString *elapsed = @"";
	
	time_t now;
    time(&now);
    
    int distance = (int)difftime(now, [self timeIntervalSince1970]);
    if (distance < 0) 
		distance = 0;
    
    if (distance < 60) {
        elapsed = [NSString stringWithFormat:@"%d %@", distance, [NSString plural:distance with1:NSLocalizedString(@"elapsed_second_1", @"1") with2:NSLocalizedString(@"elapsed_second_2", @"2") with5:NSLocalizedString(@"elapsed_second_5", @"5")]];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        elapsed = [NSString stringWithFormat:@"%d %@", distance, [NSString plural:distance with1:NSLocalizedString(@"elapsed_minute_1", @"1") with2:NSLocalizedString(@"elapsed_minute_2", @"2") with5:NSLocalizedString(@"elapsed_minute_5", @"5")]];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        elapsed = [NSString stringWithFormat:@"%d %@", distance, [NSString plural:distance with1:NSLocalizedString(@"elapsed_hour_1", @"1") with2:NSLocalizedString(@"elapsed_hour_2", @"2") with5:NSLocalizedString(@"elapsed_hour_5", @"5")]];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
       elapsed = [NSString stringWithFormat:@"%d %@", distance, [NSString plural:distance with1:NSLocalizedString(@"elapsed_day_1", @"1") with2:NSLocalizedString(@"elapsed_day_2", @"2") with5:NSLocalizedString(@"elapsed_day_5", @"5")]];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        elapsed = [NSString stringWithFormat:@"%d %@", distance, [NSString plural:distance with1:NSLocalizedString(@"elapsed_week_1", @"1") with2:NSLocalizedString(@"elapsed_week_2", @"2") with5:NSLocalizedString(@"elapsed_week_5", @"5")]];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        result = [dateFormatter stringFromDate:self];
    }
	
    return ([elapsed length]) ? [NSString stringWithFormat:NSLocalizedString(@"elapsed_ago", @""), elapsed] : result;
}

+ (NSMutableDictionary *)calculateDates:(NSDate *)fromDate toDate:(NSDate *)toDate {
	NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	// Calculate years
	NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components year]] forKey:@"years"];
	
	// Calculate months
	components = [gregorian components:NSMonthCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components month]] forKey:@"months"];
	
	// Calculate weeks
	components = [gregorian components:NSWeekCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components week]] forKey:@"weeks"];
	
	// Calculate days
	components = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components day]] forKey:@"days"];
	
	// Calculate hours
	components = [gregorian components:NSHourCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components hour]] forKey:@"hours"];
	
	// Calculate minutes
	components = [gregorian components:NSMinuteCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components minute]] forKey:@"minutes"];
	
	// Calculate seconds
	components = [gregorian components:NSSecondCalendarUnit fromDate:fromDate toDate:toDate options:0];
	[dic setObject:[NSNumber numberWithInt:[components second]] forKey:@"seconds"];
	
	return dic;
}

- (NSDate *)roundDateToCeilingMinutes:(int)minute {
	NSDateComponents *time = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self];
	NSInteger minutes = [time minute];
	int remain = minutes % minute;
	NSDate *d = [self dateByAddingTimeInterval:60 * (minute - remain)];
	return d;
}

- (NSInteger)dayOfWeek{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    return [weekdayComponents weekday];
}

- (NSInteger)dayOfMonth{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd"];
    return [[df stringFromDate:self] intValue];
}

- (NSInteger)year{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *yearComponents = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [yearComponents year];
}

- (NSInteger)yearDay{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    return [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self];;
}

@end
