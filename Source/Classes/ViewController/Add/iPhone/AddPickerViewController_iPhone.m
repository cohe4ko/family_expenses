//
//  AddPickerViewController_iPhone.m
//  Expenses
//

#import "AddPickerViewController_iPhone.h"

@interface AddPickerViewController_iPhone (Private)
@end

@implementation AddPickerViewController_iPhone

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