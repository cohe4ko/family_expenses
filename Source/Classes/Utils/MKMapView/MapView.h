//
//  MapView.h
//  WhereIGO
//
//  Created by Vinogradov Sergey on 08.06.10.
//  Copyright 2010 AppMake.Ru All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface MapView : UIView <MKMapViewDelegate, CLLocationManagerDelegate> {
	MKMapView *mapView;
	
	CLLocationManager *locationManager;
	CLLocationCoordinate2D currentLocation;
	
	Annotation *annotation;
	NSMutableArray *annotations;
}

@property (nonatomic, retain) Annotation *annotation;
@property (nonatomic, retain) NSMutableArray *annotations;

- (void)showUserLocation:(BOOL)yesOrNo;

- (void)locate;

- (void)centerMapUser;
- (void)centerMapAnnotations;

- (void)setAnnotations:(NSMutableArray *)annotations;

@end
