//
//  NSString+Utils.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (NSString *)md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	NSString *strMd5 = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];	
	return [strMd5 lowercaseString];
}

+ (NSString *)plural:(int)num withName:(NSString *)name {
	NSString *t1 = [NSString stringWithFormat:@"plural_%@_1", name];
	NSString *t2 = [NSString stringWithFormat:@"plural_%@_2", name];
	NSString *t5 = [NSString stringWithFormat:@"plural_%@_5", name];
	return [NSString plural:num with1:NSLocalizedString(t1, @"") with2:NSLocalizedString(t2, @"") with5:NSLocalizedString(t5, @"")];
}

+ (NSString *)plural:(int)num with1:(NSString *)t1 with2:(NSString *)t2 with5:(NSString *)t5 {
	int n = abs(num) % 100;
	int n1 = n % 10;
	if (n > 10 && n < 20) return t5;
	if (n1 > 1 && n1 < 5) return t2;
	if (n1 == 1) return t1;
	return t5;
}

+ (NSString *)decodeHtmlUnicodeCharactersToString:(NSString *)str {
    NSMutableString *string = [[NSMutableString alloc] initWithString:str];
    NSString *unicodeStr = nil;
    NSString *replaceStr = nil;

	int counter = -1;
	
	for(int i = 0; i < [string length]; ++i) {
		unichar char1 = [string characterAtIndex:i];    
		for (int k = i + 1; k < [string length] - 1; ++k) {
			unichar char2 = [string characterAtIndex:k];    
			
			if (char1 == '&'  && char2 == '#') {   
				++counter;
				unicodeStr = [string substringWithRange:NSMakeRange(i + 2 , 2)];    
                // read integer value i.e, 39
				replaceStr = [string substringWithRange:NSMakeRange (i, 5)];
				[string replaceCharactersInRange: [string rangeOfString:replaceStr] withString:[NSString stringWithFormat:@"%c",[unicodeStr intValue]]];
				break;
			}
		}
	}
	[string autorelease];
	
	if (counter > 1)
		return  [self decodeHtmlUnicodeCharactersToString:string]; 
	else
		return string;
}

+ (NSString *)genRandStringLength:(int)len {
	char chars[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";
	NSMutableString *ret = [[[NSMutableString alloc] initWithCapacity:len] autorelease];
	srandomdev();
	for(int i = 0;i < len; i++) {
		int index = random() % 62;
		char a = chars[index];
		//[ret appendString:[NSString stringWithCString:a length:1]];
		[ret appendString:[[[NSString alloc] initWithBytes:&a length:1 encoding:NSUTF8StringEncoding] autorelease]];
	}
	
	return ret;
}

- (NSString *)uppercaseFirst {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
}

+ (NSString *)formatCurrency:(int)number {
	return [NSString formatCurrency:number def:@"-"];
}

+ (NSString *)formatCurrency:(int)number def:(NSString *)def {
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setCurrencyDecimalSeparator:@""];
	[numberFormatter setCurrencySymbol:@""];
	[numberFormatter setMaximumFractionDigits:2];
	[numberFormatter setPositiveFormat:@"# ###"];
	return (number) ? [numberFormatter stringFromNumber:[NSNumber numberWithInt:number]] : def;
}

+ (NSString *)formatCurrency:(float)number
                currencyCode:(NSString*)currencySymbol
              numberOfPoints:(int)numberOfPoints
                  orietation:(int)backward{
    NSString *amountStr = nil;
    NSString *currencyFormat = nil;
        
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setCurrencyDecimalSeparator:@""];
	[numberFormatter setCurrencySymbol:@""];
	[numberFormatter setMaximumFractionDigits:2];
	[numberFormatter setPositiveFormat:@"# ###"];
    currencyFormat = [numberFormatter stringFromNumber:[NSNumber numberWithInt:number]];
    
    if (backward == 1) {
        amountStr = [NSString stringWithFormat:@"%@ %@",currencyFormat,currencySymbol];
    }else {
        amountStr = [NSString stringWithFormat:@"%@ %@",currencySymbol,currencyFormat];
    }
    
    return amountStr;
}


+ (NSString *)intOnly:(NSString *)string {
	NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
	for(int i = 0; i < [string length]; i++) {
		char next = [string characterAtIndex:i];
		if(next >= '0' && next <= '9') 
			[res appendFormat:@"%c", next];
		
	}
	return res;
}

@end
