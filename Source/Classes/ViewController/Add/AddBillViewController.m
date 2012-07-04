//
//  AddBillViewController.m
//  Expenses
//

#import "AddBillViewController.h"
#import "AddPickerViewController.h"
#import "PickerDateViewController.h"
#import "CalculatorViewController.h"
#import "CategoriesController.h"

#import "NSDate+Utils.h"

@interface AddBillViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
- (void)setButtonPage;
- (void)setCategoryName;
- (void)setPrice:(NSNumber*)price;
@end

@implementation AddBillViewController

@synthesize list, listCategories, category, transaction, amount;

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Fix button hide state
	[buttonOk setAlpha:0.0f];
	[buttonOk setHidden:NO];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Set button back
	[self setButtonBack:NSLocalizedString(@"back", @"Back")];
	
	buttonOk = [AMButton withTypeButton:AMButtonTypeDefault];
	[buttonOk setTitle:NSLocalizedString(@"ok", @"") forState:UIControlStateNormal];
	[buttonOk addTarget:self action:@selector(actionKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
	[buttonOk setHidden:YES];
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:buttonOk] autorelease]];
}

- (void)makeLocales {
	
	// Set hint
	[labelHint setText:NSLocalizedString(@"add_bill_hint", @"")];
	
	[buttonRecurring setTitle:NSLocalizedString(@"add_bill_button_recurring", @"") forState:UIControlStateNormal];
	
	// Set button done title
	[buttonDone setTitle:NSLocalizedString(@"add_bill_button_done", @"") forState:UIControlStateNormal];
}

- (void)makeItems {
	
	// Set textview params
	[textView setPlaceholder:NSLocalizedString(@"add_bill_note_placeholder", @"")];
	[textView setPlaceholderColor:[UIColor grayColor]];
	[textView setNumberOfLines:3];
	[textView.layer setCornerRadius:11];
	[textView.layer setBorderColor:[UIColor colorWithHexString:@"d8d8d8"].CGColor];
	[textView.layer setBorderWidth:1.0f];
	
	// If new transaction, init it
	if (!transaction) {
		Transactions *t = [Transactions create];
		t.amount = amount;
		self.transaction = t;
	}else {
        textView.text = transaction.desc;
        labelPrice.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(actionEditPrice:)];
        [labelPrice addGestureRecognizer:tap];
        [tap release];
    }
	
	// Set background image
	[buttonDate setBackgroundImage:[[buttonDate backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
	[buttonRecurring setBackgroundImage:[[buttonRecurring backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal];
	
	[imageComment setImage:[imageComment.image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f]];
	[imageCommentBorder setImage:[imageCommentBorder.image stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f]];
	[imageViewName setImage:[imageViewName.image stretchableImageWithLeftCapWidth:imageViewName.image.size.width / 2 topCapHeight:imageViewName.image.size.height / 2]];
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
	
	// Make icons list
	self.list = [[NSMutableArray alloc] init];
	self.listCategories = [[NSMutableArray alloc] init];
	if (category.parentId) {
		Categories *categoryParent = [CategoriesController getByParent:category.parentId];
		[categoryParent setPosition:-1];
		[self.list addObject:categoryParent];
		for (Categories *m in categoryParent.childs) {
			[self.list addObject:m];
		}
	}
	else {
		[category setPosition:-1];
		[self.list addObject:category];
		for (Categories *m in category.childs)
			[self.list addObject:m];
	}
	
	// Sort list
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease];
	[self.list sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	
	// Check selected index
	selectedIndex = 0;
	int i = 0;
	for (Categories *m in self.list) {
		if (m.Id == category.Id)
			selectedIndex = i;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[imageView setContentMode:UIViewContentModeCenter];
		[imageView setImage:m.imageNormal];
		[imageView setAlpha:0.7];
		[imageView setTag:i];
		[listCategories addObject:imageView];
		[imageView release];
		
		i++;
	}
	
	// Make scrollview
	iconWidth = self.view.frame.size.width / 5.0f;
	iconHeight = 71.0f;
	
	[scrollView setWidth:iconWidth andHeight:iconHeight];
	[scrollView setIsdelegate:self];
    [scrollView setContentSize:CGSizeMake([self.list count] * iconWidth , scrollView.contentSize.height)];
    [scrollView setPickRect:CGRectZero andDefaultIndex:selectedIndex];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDone:(id)sender {
	
	// Set selected category
	Categories *c = [self.list objectAtIndex:selectedIndex];
	transaction.categoriesId = c.Id;
	transaction.categoriesParentId = c.parentId;
	
	// Set desc
	transaction.desc = textView.text;
	
	// Save transaction
	[transaction save];
	
	// Send notification
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
	
	// Go back
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	[self performSelector:@selector(actionDoneComplete) withObject:nil afterDelay:0.2];
}

- (void)actionDoneComplete {
	
	// Change tab
	[[AppDelegate shared].tabBarController setSelectedIndex:0];
}

- (IBAction)actionDate:(id)sender {
	PickerDateViewController *controller = [MainController getViewController:@"PickerDateViewController"];
	[controller setValue:transaction.date];
	[controller setParent:self];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionRecurring:(id)sender {
	AddPickerViewController *controller = [MainController getViewController:@"AddPickerViewController"];
	if (transaction.repeatType >= 0 && transaction.repeatValue >= 0) {
		[controller setValue:[NSNumber numberWithInt:transaction.repeatValue]];
		[controller setPickerType:transaction.repeatType];
	}
	[controller setParent:self];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionButtonPage:(UIButton *)sender {
	
}

- (void)actionPickerSelect:(NSDictionary *)item {
	
	// Save params
	transaction.repeatType = [[item objectForKey:@"type"] intValue];
	transaction.repeatValue = [[item objectForKey:@"value"] intValue];
	
	// Change label recurring
	[labelRecurring setText:transaction.repeatName];
}

- (void)actionPickerDateSelect:(NSDate *)date {
	
	// Save params 
	transaction.time = [date timeIntervalSince1970];
	
	// Change label date
	[buttonDate setTitle:[transaction.date dateFormat:NSLocalizedString(@"add_bill_date_format", @"")] forState:UIControlStateNormal];
}

- (void)actionKeyboardHide {
	[textView resignFirstResponder];
}

- (void)actionEditPrice:(UITapGestureRecognizer*)sender{
    CalculatorViewController *controller = [MainController getViewController:@"CalculatorViewController"];
	[controller setParent:self];
	[controller setSelectorBack:@selector(setPrice:)];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

-(void)actionScrollTap:(UITapGestureRecognizer*)sender{
    ISView *view = (ISView*)sender.view;
    [scrollView selectIndex:[scrollView.viewArray indexOfObject:view]];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	// Set price
	[labelPrice setText:[NSString stringWithFormat:@"%d %@", (int)transaction.amount, @"руб"]];
	
	// Set date
	[buttonDate setTitle:[transaction.date dateFormat:NSLocalizedString(@"add_bill_date_format", @"")] forState:UIControlStateNormal];
	
	// Set recurring
	[labelRecurring setText:transaction.repeatName];
}

- (void)setPrice:(NSNumber*)price{
    transaction.amount = [price floatValue];
    [labelPrice setText:[NSString stringWithFormat:@"%d %@", (int)[price floatValue], @"руб"]];
}

- (void)setCategoryName {
	
	// Get selected category
	Categories *c = [self.list objectAtIndex:selectedIndex];
	
	[UIView animateWithDuration:0.2f animations:^{
		[labelName setAlpha:0.0f];
		[imageViewName setAlpha:0.0f];
	} completion:^(BOOL finished) {
		
		CGRect r;
		
		// Set category name
		[labelName setText:c.name];
		[labelName sizeToFit];
		[labelName setCenter:CGPointMake(self.view.frame.size.width / 2, imageViewName.center.y)];
		
		// Change image background name rect and center
		r = imageViewName.frame;
		r.size.width = labelName.frame.size.width + 14.0f;
		imageViewName.frame = r;
		
		[imageViewName setCenter:CGPointMake(self.view.frame.size.width / 2, imageViewName.center.y)];
		
		[UIView animateWithDuration:0.2f animations:^{
			[labelName setAlpha:1.0f];
			[imageViewName setAlpha:1.0f];
		}];
	}];
}

#pragma mark -
#pragma mark ISScrollViewDelegate

- (NSInteger)numberOfSubViews:(ISScrollView *)_scrollView {
    return [self.list count];
}

- (ISView *)viewForScroll:(ISScrollView *)_scrollView AtIndex:(NSInteger)_index {
    static NSString *indentifier = @"cell";
    ISView *view = [_scrollView dequeueReusableCellWithIdentifier:indentifier];
    if (view == nil) {
        view = [[ISView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconWidth - 2.0f, iconHeight) andIndentifier:indentifier];
        view.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                            action:@selector(actionScrollTap:)];
        [view addGestureRecognizer:tap];
        [tap release];
        
		UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconWidth - 2.0f, iconHeight)] autorelease];
		[imageView setContentMode:UIViewContentModeCenter];
		[imageView setTag:200];
		[view addSubview:imageView];
    }
	
	UIImageView *tmpImage = [self.listCategories objectAtIndex:_index];
	UIImageView *imageView = (UIImageView *)[view viewWithTag:200];
	[imageView setAlpha:0.6f];
	[imageView setImage:tmpImage.image];
    	
    return view;
}

- (void)scrollView:(ISScrollView *)_scrollView ChangeSelectedFrom:(NSIndexPath *)selOld to:(NSIndexPath *)selNew {
	
	// Set selected index
	selectedIndex = selNew.row;
	
	// Clear old
	for (ISView *view in _scrollView.viewArray) {
		UIImageView *imageView = (UIImageView *)[view viewWithTag:200];
		[imageView setAlpha:0.6f];
	}
	
	// Set new
	ISView *view = [scrollView currentSelect];
	UIImageView *imageView = (UIImageView *)[view viewWithTag:200];
	[imageView setAlpha:1.0f];
	
	// Set category name
	[self setCategoryName];
}

#pragma mark -
#pragma mark UITextViewDelegate

#pragma mark -
#pragma mark Notifications

- (void)keyboardDidShow:(CGFloat)height {
	[viewOverlay setAlpha:1.0f];
	[imageComment setAlpha:0.0f];
	[textView setBackgroundColor:[UIColor whiteColor]];
	[buttonOk setAlpha:1.0f];
}

- (void)keyboardDidHide:(CGFloat)height {
	[viewOverlay setAlpha:0.0f];
	[imageComment setAlpha:1.0f];
	[textView setBackgroundColor:[UIColor clearColor]];
	[buttonOk setAlpha:0.0f];
}

#pragma mark -
#pragma mark Touches event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Hide keyboard
	[textView resignFirstResponder];
	
	[super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[scrollView release];
	scrollView = nil;
	[labelHint release];
	labelHint = nil;
	[buttonDone release];
	buttonDone = nil;
	[scrollView release];
	scrollView = nil;
	[imageLen release];
	imageLen = nil;
	[buttonDate release];
	buttonDate = nil;
	[buttonRecurring release];
	buttonRecurring = nil;
	[imageComment release];
	imageComment = nil;
	[textView release];
	textView = nil;
	[imageViewName release];
	imageViewName = nil;
	[labelName release];
	labelName = nil;
	[buttonPageLeft release];
	buttonPageLeft = nil;
	[buttonPageRight release];
	buttonPageRight = nil;
	[labelRecurring release];
	labelRecurring = nil;
	[labelPrice release];
	labelPrice = nil;
	[viewOverlay release];
	viewOverlay = nil;
	[imageCommentBorder release];
	imageCommentBorder = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[labelHint release];
	[buttonDone release];
	[scrollView release];
	[category release];
	[list release];
	[listCategories release];
	[imageLen release];
	[buttonDate release];
	[buttonRecurring release];
	[imageComment release];
	[textView release];
	[imageViewName release];
	[labelName release];
	[buttonPageLeft release];
	[buttonPageRight release];
	[labelRecurring release];
	[transaction release];
	[labelPrice release];
	[viewOverlay release];
	[imageCommentBorder release];
    [super dealloc];
}

@end