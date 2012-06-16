//
//  RootViewController_iPad.m
//  BookAero
//
//  Created by Vinogradov Sergey on 19.12.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "RootViewController_iPad.h"
#import "AppDelegate.h"
#import "UIImage+ScaledImage.h"
#import "Constants.h"

@implementation RootViewController_iPad

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)runThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[pool release];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
	[super didRotateFromInterfaceOrientation:interfaceOrientation];
}

@end
