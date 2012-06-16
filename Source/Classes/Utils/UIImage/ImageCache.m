//
//  ImageCache.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "ImageCache.h"
#import "File.h"

@implementation ImageCache

static ImageCache *sharedImageCache;

- (id)init {
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

+ (ImageCache *)sharedImageCache {
    if (!sharedImageCache) {
        sharedImageCache = [[ImageCache alloc] init];
    }
    return sharedImageCache;
}

- (id)readData:(NSString *)path {
	if (![_data valueForKey:path]) {
		NSData *data = [File readFile:path];
		if (data)
			[_data setObject:data forKey:path];
		//[data release];
		//data = nil;
 	}
	return [_data valueForKey:path];
}

- (void)storeData:(NSData *)data forDir:(NSString *)dir forFile:(NSString *)file {
	// Сохраняем файл в файловую систему
	if ([File checkAndMakeDir:dir]) {
		[File writeFile:file data:data];
	}
    [_data setObject:data forKey:file];
}

@end
