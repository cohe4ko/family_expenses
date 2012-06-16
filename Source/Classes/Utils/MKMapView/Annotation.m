//
//  Annotation.m
//  Tripmonster
//
//  Created by Sergey Vinogradov on 23.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize imageURL = _imageURL;
@synthesize object, target, action, tag;

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate imageURL:(NSURL *)imageURL {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
		_imageURL = [imageURL copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (void)dealloc {
    [_name release];
    _name = nil;
    [_address release];
    _address = nil;
	[_imageURL release];
	_imageURL = nil;
	[object release];
	[target release];
    [super dealloc];
}

@end
