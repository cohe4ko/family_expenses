//
//  MapView.m
//  WhereIGO
//
//  Created by Vinogradov Sergey on 08.06.10.
//  Copyright 2010 AppMake.Ru All rights reserved.
//

#import "MapView.h"
#import "DataManager.h"

@interface MapView(Private)
- (void)initMap;
@end

@implementation MapView

@synthesize annotation, annotations;

- (void)awakeFromNib {
	[self initMap];
}

- (id)initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self initMap];
	}
	return self;
}

- (void)initMap {
	mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
	[mapView setDelegate:self];
	[self addSubview:mapView];
}

#pragma mark -
#pragma mark Set

- (void)setAnnotation:(Annotation *)_annotation {
	if (_annotation != annotation) {
		[annotation release];
		annotation = [_annotation retain];
		
		[mapView addAnnotation:annotation];
		[self locate];
	}
}

- (void)setAnnotations:(NSMutableArray *)_annotations {
	if (annotations != _annotations) {
		[_annotations retain];
		[annotations release];
		annotations = _annotations;
 		
		// Remove old annotations
		for (id <MKAnnotation> _annotation in mapView.annotations) {
			if ([_annotation isKindOfClass:[Annotation class]])
				[mapView removeAnnotation:_annotation];
		}
		
		int idx = 0;
		for (Annotation *_annotation in annotations)
			_annotation.tag = idx++;
		
		// Add new annotations
		[mapView addAnnotations:annotations];
		
		// Zoom region to fit annotations
		[self centerMapAnnotations];
	}
}

#pragma mark -
#pragma mark Show

- (void)showUserLocation:(BOOL)yesOrNo {
	mapView.showsUserLocation = yesOrNo;
}

- (void)showAnnotation {
	[mapView selectAnnotation:annotation animated:YES]; 
}

- (void)locate {	
	MKCoordinateRegion region;
	region.center = annotation.coordinate;
	
	MKCoordinateSpan span;
	span.latitudeDelta = 0.01;
	span.longitudeDelta = 0.01;
	region.span = span;
	
	[mapView setRegion:region animated:TRUE];
}

- (void)centerMapUser {
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.004;
	span.longitudeDelta = 0.004;
	
	CLLocationCoordinate2D location2D;
	location2D.latitude = currentLocation.latitude;
	location2D.longitude = currentLocation.longitude;
	
	region.span = span;
	region.center = location2D;
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
}

- (void)centerMapAnnotations {
	MKMapRect zoomRect = MKMapRectNull;
	for (id <MKAnnotation> _annotation in mapView.annotations) {
		MKMapPoint annotationPoint = MKMapPointForCoordinate(_annotation.coordinate);
		MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
		if (MKMapRectIsNull(zoomRect)) {
			zoomRect = pointRect;
		} else {
			zoomRect = MKMapRectUnion(zoomRect, pointRect);
		}
	}
	[mapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark -
#pragma mark MKMapView delegate

- (void)mapView:(MKMapView *)_mapView regionWillChangeAnimated:(BOOL)animated {
	
}

- (void)mapView:(MKMapView *)_mapView regionDidChangeAnimated:(BOOL)animated {
	
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id)_annotation {
	
	if ([_annotation isKindOfClass:[MKUserLocation class]]) {
		MKUserLocation *user = (MKUserLocation *)_annotation;
		user.title = NSLocalizedString(@"current_location", @"");
        user.subtitle = NSLocalizedString(@"your_here", @"");
		
		NSString *identifier = @"AnnotationUser";
		MKPinAnnotationView *annotationUser = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if (annotationUser == nil) {
			annotationUser = [[[MKPinAnnotationView alloc] initWithAnnotation:_annotation reuseIdentifier:identifier] autorelease];
		}
		
		annotationUser.enabled = YES;
        annotationUser.canShowCallout = YES;
		annotationUser.pinColor = MKPinAnnotationColorGreen;
		return annotationUser;
	}
	
	if ([_annotation isKindOfClass:[Annotation class]]) {
		static NSString *identifier = @"AnnotationView";
		
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if (annotationView == nil) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:_annotation reuseIdentifier:identifier] autorelease];
		} 
		else {
			annotationView.annotation = _annotation;
		}
		
		annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
		annotationView.animatesDrop = YES;
		annotationView.pinColor = MKPinAnnotationColorRed;
		
		Annotation *a = (Annotation *)_annotation;
		if (a.object && a.target && [a.target respondsToSelector:a.action]) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
			[button sizeToFit];
			[button setTag:a.tag];
			[button addTarget:self action:@selector(actionDetail:) forControlEvents:UIControlEventTouchUpInside];
			annotationView.rightCalloutAccessoryView = button;
		}
		
		[self performSelector:@selector(showAnnotation) withObject:nil afterDelay:0.3];
		
		return annotationView;
	}
	
	return nil;
}

#pragma mark -
#pragma mark Actions

- (void)actionDetail:(UIButton *)button {
	if ([annotations count]) {
		for (Annotation *_annotation in annotations) {
			if (_annotation.tag == button.tag) {
				[_annotation.target performSelector:_annotation.action withObject:_annotation.object];
				break;
			}
		}
	}
	if (annotation) {
		[annotation.target performSelector:annotation.action withObject:annotation.object];
	}
}

#pragma mark -
#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {  
	[manager stopUpdatingLocation];
	currentLocation = newLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location error");
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[mapView release];
	[annotation release];
	[annotations release];
    [super dealloc];
}

@end
