//
//  ImageAsyncDownload.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "ImageAsyncDownload.h"
#import "ImageCache.h"

@interface ImageAsyncDownload (Private)
- (void)releaseConnectionAndData;
- (void)clickImage;
@end

@implementation ImageAsyncDownload

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	isLock = FALSE;
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent*)event {
	isLock = TRUE;
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	timer = [NSTimer scheduledTimerWithTimeInterval:0.20f target:self selector:@selector(clickImage) userInfo:nil repeats:NO];
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 2) {
		isLock = TRUE;
		[super touchesEnded:touches withEvent:event];
	}
}

- (void)clickImage {
	[timer invalidate];
	if (!isLock)
		[delegate performSelector:operation withObject:self];
}

- (void)setDelegate:(id)aDelegate operation:(SEL)anOperation {
    delegate = aDelegate;
    operation = anOperation;
}

#pragma mark -
#pragma mark Memory Management

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
	if (self = [super initWithImage:image]) {
    }
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)loadImageFromURL:(NSURL *)theUrl cacheDir:(NSString *)theDir cacheFile:(NSString *)theFile {
    
	ImageCache *cache =  [ImageCache sharedImageCache];
	
    [self releaseConnectionAndData];
	
    url = [theUrl retain];
	dir = [theDir retain];
	file = [theFile retain];
	
    NSData *cachedData = [cache readData:file];
	
    if (cachedData) {
        self.image = [UIImage imageWithData:cachedData];
    } else {
        self.image = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse*)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data == nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	ImageCache *cache = [ImageCache sharedImageCache];
    [cache storeData:data forDir:dir forFile:file];
	
    self.image = [UIImage imageWithData:data];
    [self releaseConnectionAndData];
}


#pragma mark -
#pragma mark Private Methods

- (void)releaseConnectionAndData {
    if (connection) {
        [connection cancel];
        [connection release];
        connection = nil;
    }

    if (data) {
        [data release];
        data = nil;
    }

    if (url) {
        [url release];
        url = nil;
    }
	
	if (dir) {
		[dir release];
		dir = nil;
	}
	
	if (file) {
		[file release];
		file = nil;
	}
}

- (void)dealloc {
    [self releaseConnectionAndData];
    [super dealloc];
}

@end
