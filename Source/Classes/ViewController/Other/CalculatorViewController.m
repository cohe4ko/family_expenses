//
//  AddCalculatorViewController.m
//  Expenses
//

#import "CalculatorViewController.h"
#import "AddBillViewController.h"

@interface CalculatorViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
- (void)setDisplay;
@end

@implementation CalculatorViewController

@synthesize category, selectorBack, parent;

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
	[labelHint setText:NSLocalizedString(@"add_calculator_hint", @"")];
	
	// Set button next title
	[buttonNext setTitle:((category) ? NSLocalizedString(@"add_calculator_button_next", @"") : NSLocalizedString(@"done", @"")) forState:UIControlStateNormal];
}

- (void)makeItems {
	
	CGRect r;
	
	// Init calculator
	calculator = [[Calculator alloc] init];
	
	[imageDisplay setImage:[imageDisplay.image stretchableImageWithLeftCapWidth:imageDisplay.image.size.width / 2 topCapHeight:0.0f]];
	
	// Set tags
	[buttonDigit0 setTag:CalcDigit0];
	[buttonDigit1 setTag:CalcDigit1];
	[buttonDigit2 setTag:CalcDigit2];
	[buttonDigit3 setTag:CalcDigit3];
	[buttonDigit4 setTag:CalcDigit4];
	[buttonDigit5 setTag:CalcDigit5];
	[buttonDigit6 setTag:CalcDigit6];
	[buttonDigit7 setTag:CalcDigit7];
	[buttonDigit8 setTag:CalcDigit8];
	[buttonDigit9 setTag:CalcDigit9];
	[buttonClear setTag:CalcClear];
	[buttonDelete setTag:CalcDelete];
	[buttonDecimal setTag:CalcDecimal];
	[buttonPlus setTag:CalcPlus];
	[buttonMinus setTag:CalcMinus];
	[buttonDivide setTag:CalcDivide];
	[buttonMultiply setTag:CalcMultiply];
	[buttonEqual setTag:CalcEqual];
	
	if (!category) {
		[imageCategory setHidden:YES];
		[imageLens setHidden:YES];
		
		r = imageDisplay.frame;
		r.origin.x = 20.0f;
		r.size.width = self.view.frame.size.width - r.origin.x * 2 + 2.0f;
		imageDisplay.frame = r;
		
		r = textFieldDisplay.frame;
		r.origin.x -= 65.0f;
		r.size.width += 65.0f;
		textFieldDisplay.frame = r;
		
		r = labelHint.frame;
		r.origin.x = 30.0f;
		labelHint.frame = r;
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionOperation:(UIButton *)sender {
	NSString *operation = @"";
	switch (sender.tag) {
		case CalcDigit0:
		case CalcDigit1:
		case CalcDigit2:
		case CalcDigit3:
		case CalcDigit4:
		case CalcDigit5:
		case CalcDigit6:
		case CalcDigit7:
		case CalcDigit8:
		case CalcDigit9:
			operation = [NSString stringWithFormat:@"%d", sender.tag];
			break;
		case CalcClear:
			operation = @"C";
			break;
		case CalcDelete:
			operation = @"D";
			break;
		case CalcDecimal:
			operation = @".";
			break;
		case CalcPlus:
			operation = @"+";
			break;
		case CalcMinus:
			operation = @"-";
			break;
		case CalcDivide:
			operation = @"/";
			break;
		case CalcMultiply:
			operation = @"x";
			break;
		case CalcEqual:
			operation = @"=";
		default:
			break;
	}
	
	// Set operation
	[calculator input:operation];
	
	// Display result
	[self setDisplay];
}

- (IBAction)actionNext:(id)sender {
	
	if (category) {
		AddBillViewController *controller = [MainController getViewController:@"AddBillViewController"];
		[controller setCategory:category];
		[controller setAmount:[textFieldDisplay.text floatValue]];
		[controller setHidesBottomBarWhenPushed:YES];
		[self.navigationController pushViewController:controller animated:YES];
	}
	else {
		if (parent && [parent respondsToSelector:selectorBack]) {
			[parent performSelector:selectorBack withObject:[NSNumber numberWithFloat:[textFieldDisplay.text floatValue]]];
			[self actionBack];
		}
	}
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	if (category) {
		
		// Set icon
		[imageCategory setImage:category.imageNormal];
	}
}

- (void)setDisplay {
	textFieldDisplay.text = [calculator displayValue];
}

- (void)setLogo{
    [self setTitle:NSLocalizedString(@"nav_calc", @"")];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[buttonNext release];
	buttonNext = nil;
	[imageLens release];
	imageLens = nil;
	[imageDisplay release];
	imageDisplay = nil;
	[super viewDidUnload];
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saved_transaction"];
	[category release];
	[calculator release];
	[buttonNext release];
	[imageLens release];
	[imageDisplay release];
	[parent release];
    [super dealloc];
}

@end