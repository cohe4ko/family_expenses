//
//  UrlDownload.m
//  iParking
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "UrlDownload.h"
#import "DataDownload.h"

@implementation UrlDownload

-(NSData *)getURL:(NSURL *)strURL {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    DataDownload *request = [DataDownload alloc];
	request.strURL = strURL;
	[[request init] retain];
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	while (request.isLoading && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
	
	[pool release];
	
	return [request urlData];
	[request release];
	
}

@end
