//
//  ReportViewController_iPhone.m
//  Expenses
//

#import "ReportViewController_iPhone.h"

@interface ReportViewController_iPhone (Private)
@end

@implementation ReportViewController_iPhone

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

- (void)dealloc {
    [super dealloc];
}

@end