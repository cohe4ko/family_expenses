//
//  PhoneNumberFormatter.m
//  Expenses
//
//  Created by Vinogradov Sergey on 02.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "PhoneNumberFormatter.h"
#import "MainController.h"

@implementation PhoneNumberFormatter

- (id)init {
	predefinedFormats = [[[MainController loadPlist:@"PhoneCodes"] objectAtIndex:0] retain];
	return self;
}

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale {
	
	locale = @"ru_RU";
	
	NSArray *localeFormats = [predefinedFormats objectForKey:locale];
	
	if(localeFormats == nil) 
		return phoneNumber;
	
	NSString *input = [self stripLocal:phoneNumber];
	
	for (NSString *phoneFormat in localeFormats) {
		int i = 0;
		
		NSMutableString *temp = [[[NSMutableString alloc] init] autorelease];
		
		for(int p = 0; temp != nil && i < [input length] && p < [phoneFormat length]; p++) {
			
			char c = [phoneFormat characterAtIndex:p];
			
			BOOL required = [self canBeInputByPhonePad:c];
			
			char next = [input characterAtIndex:i];
			
			switch(c) {
				case '$':
					p--;
					[temp appendFormat:@"%c", next]; 
					i++;
					break;
				case '#':
					if(next < '0' || next > '9') {
						temp = nil;
						break;
					}
					[temp appendFormat:@"%c", next]; i++;
					break;
				default:
					if(required) {
						if(next != c) {
							temp = nil;
							break;
						}
						[temp appendFormat:@"%c", next]; i++;
					} 
					else {
						[temp appendFormat:@"%c", c];
						if(next == c) 
							i++;
					}
					break;
			}
			
		}
		
		if(i == [input length]) {
			return temp;
		}
	}
	
	return input;
	
}

- (NSString *)strip:(NSString *)phoneNumber {
	NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
	for(int i = 0; i < [phoneNumber length]; i++) {
		char next = [phoneNumber characterAtIndex:i];
		if([self canBeInputByPhonePadCustom:next])
			[res appendFormat:@"%c", next];
		
	}
	return res;
}

- (NSString *)stripLocal:(NSString *)phoneNumber {
	NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
	for(int i = 0; i < [phoneNumber length]; i++) {
		char next = [phoneNumber characterAtIndex:i];
		if([self canBeInputByPhonePad:next])
			[res appendFormat:@"%c", next];
		
	}
	return res;
}

- (NSString *)stripLocal2:(NSString *)phoneNumber {
	NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
	for(int i = 0; i < [phoneNumber length]; i++) {
		char next = [phoneNumber characterAtIndex:i];
		if([self canBeInputByPhonePadLocal2:next])
			[res appendFormat:@"%c", next];
		
	}
	return res;
}

- (BOOL)canBeInputByPhonePad:(char)c {
	if(c == '+' || c == '+' || c == '+') 
		return NO;
	if(c >= '0' && c <= '9') 
		return YES;
	return NO;
}

- (BOOL)canBeInputByPhonePadCustom:(char)c {
	if(c >= '0' && c <= '9') 
		return YES;
	return NO;
}

- (BOOL)canBeInputByPhonePadLocal2:(char)c {
	if (c == '+') 
		return YES;
	if (c >= '0' && c <= '9') 
		return YES;
	return NO;
}

- (void)dealloc {
	[predefinedFormats release];
	[super dealloc];
}

@end