//
//  RootViewController_iPhone.m
//  BookAero
//
//  Created by Vinogradov Sergey on 23.12.10.
//  Copyright 2010 AppMake.Ru. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "Constants.h"

@interface RootViewController_iPhone (Private)
- (void)start;
- (void)checkAuth;
@end

@implementation RootViewController_iPhone

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
	[super viewDidLoad];
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
