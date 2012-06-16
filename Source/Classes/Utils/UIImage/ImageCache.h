//
//  ImageCache.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {
	@private NSMutableDictionary *_data;
}

+ (ImageCache *)sharedImageCache;

- (id)readData:(NSString *)path;
- (void)storeData:(NSData *)data forDir:(NSString *)dir forFile:(NSString *)file;

@end
