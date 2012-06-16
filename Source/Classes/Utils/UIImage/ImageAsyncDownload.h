//
//  ImageAsyncDownload.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageAsyncDownload : UIImageView {
	id delegate;
	SEL operation;
	BOOL isLock;
	NSTimer *timer;

@private
	NSURLConnection *connection;
	NSMutableData *data;
	NSURL *url;
	NSString *dir;
	NSString *file;
}

- (void)setDelegate:(id)aDelegate operation:(SEL)anOperation;
- (void)loadImageFromURL:(NSURL *)theUrl cacheDir:(NSString *)theDir cacheFile:(NSString *)theFile;

@end
