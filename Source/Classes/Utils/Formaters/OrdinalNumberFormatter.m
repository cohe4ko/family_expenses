//
//  OrdinalNumberFormatter.m
//  Expenses
//
//  Created by Dmitry Suhorukov on 6/3/12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "OrdinalNumberFormatter.h"

@implementation OrdinalNumberFormatter
- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
    NSInteger integerNumber;
    NSScanner *scanner;
    BOOL isSuccessful = NO;
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    
    scanner = [NSScanner scannerWithString:string];
    [scanner setCaseSensitive:NO];
    [scanner setCharactersToBeSkipped:letters];
    
    if ([scanner scanInteger:&integerNumber]){
        isSuccessful = YES;
        if (anObject) {
            *anObject = [NSNumber numberWithInteger:integerNumber];
        }
    } else {
        if (error) {
            *error = [NSString stringWithFormat:@"Unable to create number from %@", string];
        }
    }
    
    return isSuccessful;
}

- (NSString *)stringForObjectValue:(id)anObject {
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    float  n = [anObject intValue]; 
    float result = n;
    
    NSString *ordinal = @"";
    
    if(n < 1E6 && n > 999)
    {
        result /= 1E3;
        ordinal = @"тыс.";
    }
    else if(n > 999999) {
        result /= 1E6;
        ordinal = @"млн.";
    }
    
    
    return [NSString stringWithFormat:@"%6.1f %@", result, ordinal];
}
@end
