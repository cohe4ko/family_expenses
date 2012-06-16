//
//  Annotation.h
//  Tripmonster
//
//  Created by Sergey Vinogradov on 23.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
	NSString *_name;
    NSString *_address;
	NSURL *_imageURL;
    CLLocationCoordinate2D _coordinate;
	id object;
	id target;
	SEL action;
	int tag;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSURL *imageURL;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) int tag;

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate imageURL:(NSURL *)imageURL;

@end