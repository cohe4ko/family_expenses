//
//  DataDownload.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "DataDownload.h"

@implementation DataDownload

@synthesize urlData; 
@synthesize connection;
@synthesize strURL;
@synthesize isLoading;

- (id)init {
	if(self = [super init]) {
        self.isLoading = YES;
		
        NSURLRequest *dataRequest = [NSURLRequest requestWithURL:self.strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
		
		NSURLConnection *c = [[NSURLConnection alloc] initWithRequest:dataRequest delegate:self];
        self.connection = c;
		[c autorelease];
		
        if (connection == nil) {
			self.urlData = nil; 
        } else {
			NSMutableData *data = [[NSMutableData alloc] init];
			self.urlData = data;
			[data release];
        }
	}
	return self;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

-(void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse*)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.urlData setLength:0];
	if ([response respondsToSelector:@selector(statusCode)]) {
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		if (statusCode >= 400) {
			[_connection cancel]; 
			//NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:NSLocalizedString(@"Server returned status code %d",@""), statusCode] forKey:NSLocalizedDescriptionKey];
			//NSError *statusError = [NSError errorWithDomain:@"NSHTTPPropertyStatusCodeKey" code:statusCode userInfo:errorInfo];
			//[self connection:_connection didFailWithError:statusError];
		}
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)incrementalData {
	[self.urlData appendData:incrementalData];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.isLoading = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.isLoading = NO;
}

- (void)dealloc {
	[self.connection cancel];
	[super dealloc];
}

@end