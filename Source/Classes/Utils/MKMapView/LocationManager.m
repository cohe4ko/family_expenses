//
//  LocationManager.m
//  iParking
//
//  Created by Vinogradov Sergey on 09.05.10.
//  Copyright 2010 Tilllate. All rights reserved.
//

#import "LocationManager.h"
#import "Constants.h"
#import "NSDate+Utils.h"

@implementation LocationManager

@synthesize locationManager;
@synthesize location;
@synthesize objectTarget;

#pragma mark -
#pragma mark Shared object

static LocationManager *shared = nil;

+ (LocationManager *)shared {
    if (!shared) {
        shared = [[LocationManager alloc] init];
    }
    return shared;
}

- (id)init {
	if (self == [super init]) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	return self;
}

- (void)getLocation:(id)target {
	objectTarget = target;
	isRespond = NO;
	[self startLocation];
}

- (void)startLocation {
#if TARGET_IPHONE_SIMULATOR
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:55.8178359f longitude:37.3990383f];
	[self locationManager:locationManager didUpdateToLocation:loc fromLocation:nil];
#else
	[locationManager startUpdatingLocation];
#endif
}

- (void)stopLocation {
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self stopLocation];
	self.location = newLocation;
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSString stringWithFormat:@"%.7f", newLocation.coordinate.latitude] forKey:@"latitude"];
	[dic setObject:[NSString stringWithFormat:@"%.7f", newLocation.coordinate.longitude] forKey:@"longitude"];
	[dic setObject:[NSString stringWithFormat:@"%d", time(0)] forKey:@"lifetime"];
	[dic setObject:[NSKeyedArchiver archivedDataWithRootObject:newLocation] forKey:@"location"];
	
	[[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"location"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if (!isRespond && objectTarget && [objectTarget respondsToSelector:@selector(locationUpdateSuccess:)]) {
		[objectTarget performSelector:@selector(locationUpdateSuccess:) withObject:self];
		isRespond = YES;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (objectTarget && [objectTarget respondsToSelector:@selector(locationUpdateFailed:)])
		[objectTarget performSelector:@selector(locationUpdateFailed:) withObject:error];
}

- (void)dealloc {
	[super dealloc];
	[locationManager release];
	[location release];
	[objectTarget release];
}

@end
