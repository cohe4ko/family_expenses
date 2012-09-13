//
//  NSString+Utils.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Utils)

+ (NSString *)md5:(NSString *)str;
+ (NSString *)plural:(int)num withName:(NSString *)name;
+ (NSString *)plural:(int)num with1:(NSString *)t1 with2:(NSString *)t2 with5:(NSString *)t5;
+ (NSString *)decodeHtmlUnicodeCharactersToString:(NSString *)str;
+ (NSString *)genRandStringLength:(int)len;
- (NSString *)uppercaseFirst;
+ (NSString *)formatCurrency:(int)number;
+ (NSString *)formatCurrency:(int)number def:(NSString *)def;
+ (NSString *)formatCurrency:(float)number
                currencyCode:(NSString*)currencySymbol
              numberOfPoints:(int)numberOfPoints
                  orietation:(int)backward;
+ (NSString *)intOnly:(NSString *)string;

@end