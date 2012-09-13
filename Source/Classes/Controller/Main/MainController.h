//
//  MainController.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "RootViewController.h"
#import "TSAlertView.h"

@interface MainController : NSObject <ASIHTTPRequestDelegate, TSAlertViewDelegate> {
	ASIHTTPRequest *request;
	ASIFormDataRequest *formRequest;
	
	NSString *_url;
	
	NSString *connectionIdentifier;
	
	id delegate;
	
	int count;
}

#pragma mark -
#pragma mark Request methods

+ (id)withDelegate:(id)theDelegate;
- (id)initWithDelegate:(id)theDelegate;

- (NSString *)loadRequest:(NSString *)url;
- (NSString *)loadForm:(NSString *)url params:(NSMutableDictionary *)params;
- (NSString *)encodeString:(NSString *)string;

- (NSString *)loadMain;

#pragma mark -
#pragma mark Other methods

+ (NSMutableArray *)loadPlist:(NSString *)name;
+ (NSMutableDictionary*)loadPlistAsDic:(NSString*)name;

+ (id)getViewController:(NSString *)controller;

@end
