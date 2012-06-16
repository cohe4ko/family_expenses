//
//  PhoneNumberFormatter.h
//  Expenses
//
//  Created by Vinogradov Sergey on 02.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumberFormatter : NSObject {
	NSMutableDictionary *predefinedFormats;
}

- (id)init;

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale;
- (NSString *)strip:(NSString *)phoneNumber;
- (NSString *)stripLocal:(NSString *)phoneNumber;
- (NSString *)stripLocal2:(NSString *)phoneNumber;

- (BOOL)canBeInputByPhonePad:(char)c;
- (BOOL)canBeInputByPhonePadCustom:(char)c;
- (BOOL)canBeInputByPhonePadLocal2:(char)c;

@end