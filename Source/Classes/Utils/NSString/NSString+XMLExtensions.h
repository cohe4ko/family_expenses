//
//  NSString+XMLExtensions.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (XMLExtensions)

+ (NSString *)encodeXMLCharactersIn : (NSString *)source;
+ (NSString *)decodeXMLCharactersIn : (NSString *)source;

@end
