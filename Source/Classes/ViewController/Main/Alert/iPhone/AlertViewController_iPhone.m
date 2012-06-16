//
//  AlertViewController_iPhone.m
//  Expenses
//
//  Created by Vinogradov Sergey on 08.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AlertViewController_iPhone.h"

@interface AlertViewController_iPhone (Private)
@end

@implementation AlertViewController_iPhone

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end