//
//  NSString+Helpers.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "NSString+Helpers.h"
#import "NSData+Base64.h"

@implementation NSString (Helpers)

#pragma mark Helpers

- (NSString *) stringByUrlEncoding {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8) autorelease];
}

- (NSString *)base64Encoding {
	NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSString *encodedString = [stringData base64EncodedString];
	return encodedString;
}

@end