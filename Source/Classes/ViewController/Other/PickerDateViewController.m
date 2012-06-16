//
//  AddPickerDateViewController.m
//  Expenses
//

#import "PickerDateViewController.h"

@interface PickerDateViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation PickerDateViewController

@synthesize parent, value, selector;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[imageNavigationbarShadow setHidden:YES];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
	
	isLoaded = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[UIView animateWithDuration:0.3 animations:^{
		[viewOverlay setAlpha:1.0f];
	}];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
}

- (void)makeLocales {
	[buttonDone setTitle:NSLocalizedString(@"add_picker_button_done", @"") forState:UIControlStateNormal];
	
	[labelHeader setText:NSLocalizedString(@"add_picker_header_date", @"")];
}

- (void)makeItems {
	
	CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(27.0f, 11.0f, pickerView.frame.size.width - 54.0f, pickerView.frame.size.height - 22.0f)];
	[mask setCornerRadius:5.0f];
	[pickerView.layer setMask:mask];
	[mask release];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDone:(id)sender {
	[UIView animateWithDuration:0.2 animations:^{
		[viewOverlay setAlpha:0.0f];
	} completion:^(BOOL finished) {
		[self dismissModalViewControllerAnimated:YES];
		if (selector && [parent respondsToSelector:selector]) {
			[parent performSelector:selector withObject:pickerView.date];
		}
		else if ([parent respondsToSelector:@selector(actionPickerDateSelect:)]) {
			[parent performSelector:@selector(actionPickerDateSelect:) withObject:pickerView.date];
		}
	}];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	[pickerView setDate:value];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[pickerView release];
	pickerView = nil;
	[buttonDone release];
	buttonDone = nil;
	[labelHeader release];
	labelHeader = nil;
	[viewOverlay release];
	viewOverlay = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[pickerView release];
	[buttonDone release];
	[labelHeader release];
	[parent release];
	[viewOverlay release];
    [super dealloc];
}

@end