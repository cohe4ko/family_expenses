//
//  NSLocale+NSLocale_Currency.m
//  Expenses
//
//  Created by MacBook iAPPLE on 19.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "NSLocale+Currency.h"

@implementation NSLocale (Currency)

//return NSArray with dictionaries country->code
+ (NSArray*)supportedCurrencyList{
    NSArray *countryList = [NSLocale ISOCountryCodes];
    NSMutableArray *currencyList = [NSMutableArray array];
    for(NSString *countryCode in countryList){
        NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
        NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components]; 
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:localeIdent] autorelease];
        NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSString *currencyCode = [locale objectForKey: NSLocaleCurrencyCode];
        NSDictionary *currencyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:countryName, @"country", currencyCode, @"currency", countryCode,@"countryCode", nil];
        [currencyList addObject:currencyDic];
    }
    return currencyList;
}

+ (NSString*)currentCurrencyCode{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString*)currencySymbolForCountryCode:(NSString*)countryCode{
    NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
    NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components]; 
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:localeIdent] autorelease];
    return [locale objectForKey:NSLocaleCurrencySymbol];
}
+ (NSString*)currencyCodeForCountryCode:(NSString*)countryCode{
    NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
    NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components]; 
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:localeIdent] autorelease];
    return [locale objectForKey:NSLocaleCurrencyCode];
}

@end
