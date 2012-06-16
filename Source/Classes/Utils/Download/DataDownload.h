//
//  DataDownload.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataDownload : NSObject {
	NSMutableData	*urlData;
	NSURLConnection *connection;
	NSURL			*strURL;
	BOOL			isLoading;
}

@property (nonatomic, retain) NSMutableData *urlData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURL	*strURL;
@property BOOL isLoading;

- (id)init;


@end