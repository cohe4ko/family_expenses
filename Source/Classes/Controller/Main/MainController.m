//
//  MainController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "MainController.h"
#import "File.h"
#import "JSON.h"

#import "DataManager.h"
#import "Constants.h"

#import "NSString+Utils.h"
#import "AppDelegate.h"

#import "ASIDownloadCache.h"

@interface MainController (Private)
- (void)loadAuth;
@end

@implementation MainController

#pragma mark -
#pragma mark Request methods

+ (id)withDelegate:(id)theDelegate {
	return [[[MainController alloc] initWithDelegate:theDelegate] autorelease];
}

- (id)initWithDelegate:(id)theDelegate {
	if ((self = [super init])) {
		connectionIdentifier = nil;
		delegate = [theDelegate retain];
		count = 0;
	}
	return self;
}

- (NSString *)loadRequest:(NSString *)url {
	_url = [url retain];
	
	NSLog(@"url - %@", _url);
	
	if ([[AppDelegate shared] checkConnection]) {
		count++;
		
		request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_url]];
		[request setDelegate:self];
		[request setDownloadCache:[ASIDownloadCache sharedCache]];
		[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
		[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
		[request setTimeOutSeconds:50.0];
		[request addRequestHeader:@"CacheControl" value:@"no-cache"];
		[request addRequestHeader:@"Connection" value:@"keep-alive"];
		[request setUseSessionPersistence:YES];
		[request startAsynchronous];
	}
	else {
		[[RootViewController shared] showLoading:NO];
		TSAlertView *alertView = [[TSAlertView alloc] initWithTitle:nil 
															message:NSLocalizedString(@"network_failed", @"") 
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") 
												  otherButtonTitles:NSLocalizedString(@"retry", @"Retry"), nil];
		[alertView setBackgroundImage:[UIImage imageNamed:@"alert_background_front.png"]];
		[alertView show];
		[alertView release];
	}
	
	if (!connectionIdentifier)
		connectionIdentifier = [[NSString genRandStringLength:40] retain];
	return connectionIdentifier;
}

- (NSString *)loadForm:(NSString *)url params:(NSMutableDictionary *)params {
	for (NSString *key in params) {
		url = [url stringByAppendingFormat:@"&%@=%@", key,[params objectForKey:key]];
	}
	return [self loadRequest:url];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
	NSString *response = [theRequest responseString];

	id result = [response JSONValue];
	
	if ([delegate respondsToSelector:@selector(requestSucceeded:forConnection:)]) {
		[delegate performSelector:@selector(requestSucceeded:forConnection:) withObject:result withObject:connectionIdentifier];
	}
	if ([delegate respondsToSelector:@selector(requestSucceeded:)]) {
		[delegate performSelector:@selector(requestSucceeded:) withObject:result withObject:connectionIdentifier];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest {
	if (count <= 10)
		[self loadRequest:_url];
	else {
		NSError *error = [theRequest error];
		if ([delegate respondsToSelector:@selector(requestFailed:forConnection:)]) {
			[delegate performSelector:@selector(requestFailed:forConnection:) withObject:error withObject:[connectionIdentifier retain]];
		}
		else if ([delegate respondsToSelector:@selector(requestFailed:)]) {
			[delegate performSelector:@selector(requestFailed:) withObject:error];
		}
	}
}

- (NSString *)encodeString:(NSString *)string {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8);
    return [result autorelease];
}

#pragma mark -
#pragma mark Server methods

- (NSString *)loadMain {
	return nil;//[self loadRequest:API_MAIN_LIST];
}

#pragma mark -
#pragma mark Other methods

+ (NSMutableArray *)loadPlist:(NSString *)name {
	NSString *error;
	NSPropertyListFormat format;
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:localizedPath];
	NSArray *data = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[data count]];
	for (NSDictionary *menuSectionDictionary in data) {
		[result addObject:menuSectionDictionary];
	}
	return [result autorelease];
}

+ (id)getViewController:(NSString *)controller {
	NSString *controllerName = [NSString stringWithFormat:@"%@_%@", controller, DEVICE_NAME];
	return [[[NSClassFromString(controllerName) alloc] initWithNibName:controllerName bundle:[NSBundle mainBundle]] autorelease];
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex) {
		[self loadRequest:_url];
	}
	else {
		if ([delegate respondsToSelector:@selector(requestFailed:forConnection:)]) {
			[delegate performSelector:@selector(requestFailed:forConnection:) withObject:nil withObject:[connectionIdentifier retain]];
		}
		else if ([delegate respondsToSelector:@selector(requestFailed:)]) {
			[delegate performSelector:@selector(requestFailed:) withObject:nil];
		}
	}
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	request.delegate = nil;
	[request clearDelegatesAndCancel];
    [request release];
	[formRequest release];
	[delegate release];
	[connectionIdentifier release];
	[super dealloc];
}

@end
