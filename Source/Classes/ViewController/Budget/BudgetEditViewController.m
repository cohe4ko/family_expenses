//
//  BudgetEditViewController.m
//  Expenses
//

#import "BudgetEditViewController.h"

#import "CalculatorViewController.h"
#import "PickerDateViewController.h"

#import "AMAnimationShake.h"

@interface BudgetEditViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
- (void)setButtonsRepeat;
@end

@implementation BudgetEditViewController

@synthesize budget;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make toolbar
	[self makeToolBar];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Set button back
	[self setButtonBack:NSLocalizedString(@"back", @"Back")];
}

- (void)makeLocales {
	
	// Set hint
	[labelHint setText:NSLocalizedString(@"budget_edit_hint", @"")];
	
	[buttonRepeatLeft setTitle:NSLocalizedString(@"budget_edit_button_repeat_weekly", @"") forState:UIControlStateNormal];
	[buttonRepeatRight setTitle:NSLocalizedString(@"budget_edit_button_repeat_monthly", @"") forState:UIControlStateNormal];
	[buttonDone setTitle:NSLocalizedString(@"budget_edit_button_done", @"") forState:UIControlStateNormal];
	
}

- (void)makeItems {
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
	
	// Set button amount
	[buttonAmount setBackgroundImage:[[buttonAmount backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
	[buttonAmount setTitle:NSLocalizedString(@"budget_edit_button_amount", @"")];
	[buttonAmount setIcon:[UIImage imageNamed:@"icon_amount.png"]];
	[buttonAmount setArrow:[UIImage imageNamed:@"icon_arrow.png"]];
	
	// Set button date from
	[buttonDateFrom setBackgroundImage:[[buttonDateFrom backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
	[buttonDateFrom setTitle:NSLocalizedString(@"budget_edit_button_date_from", @"")];
	[buttonDateFrom setIcon:[UIImage imageNamed:@"icon_calendar.png"]];
	[buttonDateFrom setArrow:[UIImage imageNamed:@"icon_arrow.png"]];
	
	// Set button date to
	[buttonDateTo setBackgroundImage:[[buttonDateTo backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
	[buttonDateTo setTitle:NSLocalizedString(@"budget_edit_button_date_to", @"")];
	[buttonDateTo setIcon:[UIImage imageNamed:@"icon_calendar.png"]];
	[buttonDateTo setArrow:[UIImage imageNamed:@"icon_arrow.png"]];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDone:(id)sender {
	
	// Check empty budget
	if (!self.budget.amount) {
		[AMAnimationShake shakeXWithObject:buttonAmount];
		return;
	}
	
	// Save budget
	[self.budget save];
	
	// Send notification
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BUDGET_UPDATE object:self.budget];
	
	// Go back
	[self actionBack];
}

- (IBAction)actionAmount:(id)sender {
	
	CalculatorViewController *controller = [MainController getViewController:@"CalculatorViewController"];
	[controller setParent:self];
	[controller setSelectorBack:@selector(setAmount:)];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionDateFrom:(id)sender {
	PickerDateViewController *controller = [MainController getViewController:@"PickerDateViewController"];
	[controller setValue:self.budget.dateFrom];
	[controller setParent:self];
	[controller setSelector:@selector(setDateFrom:)];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionDateTo:(id)sender {
	PickerDateViewController *controller = [MainController getViewController:@"PickerDateViewController"];
	[controller setValue:self.budget.dateTo];
	[controller setParent:self];
	[controller setSelector:@selector(setDateTo:)];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionRepeat:(UIButton *)sender {
	self.budget.repeat = (sender == buttonRepeatLeft) ? BudgetRepeatWeek : BudgetRepeatMonth;
	[self setButtonsRepeat];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	if (!budget) {
		
		// Create empty budget object
		self.budget = [Budget create];
	}
		
	// Set default labels
	[buttonAmount setValue:((self.budget.amount) ? [NSString stringWithFormat:@"%d %@", (int)self.budget.amount, @"руб"] : NSLocalizedString(@"budget_edit_placeholder_amount", @""))];
	
	// Set dates
	[buttonDateFrom setValue:[self.budget.dateFrom dateFormat:NSLocalizedString(@"budget_edit_date_format", @"")]];
	[buttonDateTo setValue:[self.budget.dateTo dateFormat:NSLocalizedString(@"budget_edit_date_format", @"")]];
	
	// Set repeat buttons state
	[self setButtonsRepeat];
}

- (void)setAmount:(NSNumber *)amount {
	self.budget.amount = [amount floatValue];
	[buttonAmount setValue:((self.budget.amount) ? [NSString stringWithFormat:@"%d %@", (int)self.budget.amount, @"руб"] : NSLocalizedString(@"budget_edit_placeholder_amount", @""))];
}

- (void)setDateFrom:(NSDate *)date {
	self.budget.timeFrom = [date timeIntervalSince1970];
	[buttonDateFrom setValue:[self.budget.dateFrom dateFormat:NSLocalizedString(@"budget_edit_date_format", @"")]];
}

- (void)setDateTo:(NSDate *)date {
	self.budget.timeTo = [date timeIntervalSince1970];
	[buttonDateTo setValue:[self.budget.dateTo dateFormat:NSLocalizedString(@"budget_edit_date_format", @"")]];
}

- (void)setButtonsRepeat {
	[buttonRepeatLeft setSelected:(self.budget.repeat == BudgetRepeatWeek)];
	[buttonRepeatRight setSelected:(self.budget.repeat == BudgetRepeatMonth)];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[buttonAmount release];
	buttonAmount = nil;
	[labelHint release];
	labelHint = nil;
	[viewOverlay release];
	viewOverlay = nil;
	[buttonDone release];
	buttonDone = nil;
	[buttonDateFrom release];
	buttonDateFrom = nil;
	[buttonDateTo release];
	buttonDateTo = nil;
	[buttonRepeatLeft release];
	buttonRepeatLeft = nil;
	[buttonRepeatRight release];
	buttonRepeatRight = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[buttonAmount release];
	[labelHint release];
	[viewOverlay release];
	[buttonDone release];
	[buttonDateFrom release];
	[buttonDateTo release];
	[buttonRepeatLeft release];
	[buttonRepeatRight release];
    [super dealloc];
}

@end