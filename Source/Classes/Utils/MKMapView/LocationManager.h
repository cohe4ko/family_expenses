//
//  LocationManager.h
//  iParking
//
//  Created by Vinogradov Sergey on 09.05.10.
//  Copyright 2010 Tilllate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *location;
	
	id objectTarget;
	BOOL isRespond;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) id objectTarget;

+ (LocationManager *)shared;

- (void)getLocation:(id)target;
- (void)startLocation;
- (void)stopLocation;

@end
