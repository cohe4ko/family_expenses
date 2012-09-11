//
//  AddPickerViewController.m
//  Expenses
//

#import "AddPickerViewController.h"

@interface AddPickerViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation AddPickerViewController

@synthesize parent, pickerType, list, value;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[imageNavigationbarShadow setHidden:YES];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
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
	[buttonLeft setTitle:NSLocalizedString(@"add_picker_button_recurring_left", @"") forState:UIControlStateNormal];
    [buttonMiddle setTitle:NSLocalizedString(@"add_picker_button_recurring_middle", @"") forState:UIControlStateNormal];
	[buttonRight setTitle:NSLocalizedString(@"add_picker_button_recurring_right", @"") forState:UIControlStateNormal];
	[buttonDone setTitle:NSLocalizedString(@"add_picker_button_done", @"") forState:UIControlStateNormal];
	
	[labelHeader setText:NSLocalizedString(@"add_picker_header_recurring", @"")];
}

- (void)makeItems {
	
	[buttonLeft setSelected:(pickerType == PickerTypeWeek)];
    [buttonMiddle setSelected:(pickerType == PickerTypeMonth)];
	[buttonRight setSelected:(pickerType == PickerTypeDontRepeat)];
	
	CALayer *mask = [[CALayer alloc] init];
	[mask setBackgroundColor:[UIColor blackColor].CGColor];
	[mask setFrame:CGRectMake(10.0f, 11.0f, pickerView.frame.size.width - 20.0f, pickerView.frame.size.height - 22.0f)];
	[mask setCornerRadius:5.0f];
	[pickerView.layer setMask:mask];
	[mask release];
    
    pickerView.hidden = NO;
    
    NSInteger idx = 0;
    NSMutableArray *tmp = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
    for (NSInteger i = 0; i < 7; i++) {
        NSString *s = [NSString stringWithFormat:@"transaction_week_%d", i];
        [[tmp objectAtIndex:0] addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i], @"value", NSLocalizedString(s, @""), @"name", nil]];
        if (pickerType == PickerTypeWeek && i == [value intValue])
            idx = i;
    }
     
    for (NSInteger i = 1; i <= 31; i++) {
        NSString *s = [NSString stringWithFormat:NSLocalizedString(@"transaction_month", @""),i];
        [[tmp objectAtIndex:1] addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i], @"value", s, @"name", nil]];
        if (pickerType == PickerTypeMonth && i == [value intValue])
            idx = i - 1;
    }

        
    self.list = tmp;
    [pickerView selectRow:idx inComponent:0 animated:NO];
    
    if (pickerType == PickerTypeDontRepeat) {
        pickerView.hidden = YES;
    }else {
        pickerView.hidden = NO;
    }

}

#pragma mark -
#pragma mark Actions


- (IBAction)actionSwitch:(UIButton *)sender {
	[buttonLeft setSelected:(sender == buttonLeft)];
    [buttonMiddle setSelected:(sender == buttonMiddle)];
	[buttonRight setSelected:(sender == buttonRight)];

    if (buttonLeft.selected) {
        self.pickerType = PickerTypeWeek;
    }else if(buttonRight.selected) {
        self.pickerType = PickerTypeDontRepeat;
    }else if(buttonMiddle.selected){
        self.pickerType = PickerTypeMonth;
    }
    
	
}

- (IBAction)actionDone:(id)sender {
	
	[UIView animateWithDuration:0.2 animations:^{
		[viewOverlay setAlpha:0.0f];
	} completion:^(BOOL finished) {
		
		[self dismissModalViewControllerAnimated:YES];
		
		if ([parent respondsToSelector:@selector(actionPickerSelect:)]) {
            if (pickerType == PickerTypeWeek || pickerType == PickerTypeMonth) {
                NSDictionary *d = [[list objectAtIndex:pickerType] objectAtIndex:[pickerView selectedRowInComponent:0]];
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:[NSNumber numberWithInt:pickerType] forKey:@"type"];
                [item setObject:[d objectForKey:@"value"] forKey:@"value"];
                [parent performSelector:@selector(actionPickerSelect:) withObject:item];
            }else if(pickerType == PickerTypeDontRepeat){
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:[NSNumber numberWithInt:-1] forKey:@"type"];
                [item setObject:[NSNumber numberWithInt:-1] forKey:@"value"];
                [parent performSelector:@selector(actionPickerSelect:) withObject:item];
            }
			
		}
	}];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
}

- (void)setPickerType:(PickerType)_pickerType {
	if (pickerType != _pickerType) {
		pickerType = _pickerType;
		
		if (!isLoaded)
			return;
		
        if (pickerType == PickerTypeWeek || pickerType == PickerTypeMonth) {
            pickerView.hidden = NO;
            value = [[[list objectAtIndex:pickerType] objectAtIndex:0] objectForKey:@"value"];
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:0 animated:NO];
        }else {
            pickerView.hidden = YES;
            value = [NSNumber numberWithInt:-1];
        }
		
	}
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)_pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)_pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerType == PickerTypeWeek || pickerType == PickerTypeMonth) {
        return [[list objectAtIndex:pickerType] count];
    }
	return 0;
}

- (UIView *)pickerView:(UIPickerView *)_pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)theView {
	NSDictionary *item = [[list objectAtIndex:pickerType] objectAtIndex:row];
	NSString *name = [item objectForKey:@"name"];
	
	theView = [[UIView alloc] initWithFrame:CGRectMake(0.00f, 0.00f, 260.00f, 32.00f)];
	[theView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if (pickerType == PickerTypeWeek) {
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    }else {
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    }
	
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor colorWithHexString:@"000000"]];
	[label setText:name];
	[label sizeToFit];
	[label setFrame:CGRectMake(30.00f, 0.00f, 230.00f, theView.frame.size.height)];
	[label alignTop];
	[theView addSubview:label];
	
	if (label.frame.size.height < 20.00f) {
		CGRect r = label.frame;
		r.size.height = 32.00f;
		label.frame = r;
	}
	
	if ([[item objectForKey:@"value"] intValue] == [value intValue]) {
		UIImageView *imageChecked = [[UIImageView alloc] initWithFrame:CGRectMake(0.00f, 0.00f, 13.00f, 13.00f)];
		[imageChecked setImage:[UIImage imageNamed:@"icon_picker_check.png"]];
		[imageChecked setCenter:CGPointMake(imageChecked.center.x, label.center.y)];
		[theView addSubview:imageChecked];
		[label setTextColor:[UIColor colorWithHexString:@"324e84"]];
	}
	[label release];
	
	return theView;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	value = [[[list objectAtIndex:pickerType] objectAtIndex:row] objectForKey:@"value"];
	[_pickerView reloadAllComponents];
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
	[buttonLeft release];
	buttonLeft = nil;
    [buttonMiddle release];
    buttonMiddle = nil;
	[buttonRight release];
	buttonRight = nil;
	[labelHeader release];
	labelHeader = nil;
	[viewOverlay release];
	viewOverlay = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	[pickerView release];
	[buttonDone release];
	[buttonLeft release];
    [buttonMiddle release];
	[buttonRight release];
	[labelHeader release];
	[parent release];
	[list release];
	[viewOverlay release];
    [super dealloc];
}

@end