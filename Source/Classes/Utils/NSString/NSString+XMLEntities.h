//
//  NSString+XMLEntities.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XMLEntities)

- (NSString *)stringByStrippingTags;
- (NSString *)stringByDecodingXMLEntities;
- (NSString *)stringByEncodingXMLEntities;
- (NSString *)stringWithNewLinesAsBRs;
- (NSString *)stringByRemovingNewLinesAndWhitespace;

@end
