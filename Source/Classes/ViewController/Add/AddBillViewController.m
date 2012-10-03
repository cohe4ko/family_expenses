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
- (void)setSelectedViewForIndex:(NSInteger)_index;
- (void)updateSelectedIndex;
- (void)textChanged:(NSNotification*)notification;
@end

#define kIconImageTag 200
#define kIconViewTag 300

@implementation AddBillViewController

@synthesize list, listCategories, category, transaction, amount;

#pragma mark -
#pragma mark Initializate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

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
        NSDictionary *tDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"saved_transaction"];
        if (tDic) {
            Transactions* t = [Transactions withDictionary:tDic];
            t.amount = amount;
            textView.text = t.desc;
            self.category = t.categories;
            self.transaction = t;
        }else{
            Transactions* t = [Transactions create];
            t.amount = amount;
            self.transaction = t;
        }
        
        btype = BillTypeAdd;
	}else {
        textView.text = transaction.desc;
        labelPrice.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(actionEditPrice:)];
        [labelPrice addGestureRecognizer:tap];
        [tap release];
        btype = BillTypeEdit;
    }
    
    [self textChanged:nil];
	
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
	
	[scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(([self.list count]+4) * iconWidth , scrollView.contentSize.height)];

    for (int i = 0; i < [self.list count]; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i+2)*iconWidth, 0, iconWidth, iconHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                            action:@selector(actionScrollTap:)];
        [view addGestureRecognizer:tap];
        [view setTag:kIconViewTag+i];
        [tap release];
        
		UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconWidth - 2.0f, iconHeight)] autorelease];
		[imageView setContentMode:UIViewContentModeCenter];
		[imageView setTag:kIconImageTag];
		[view addSubview:imageView];
        
        UIImageView *tmpImage = [self.listCategories objectAtIndex:i];
        [imageView setAlpha:0.6f];
        [imageView setImage:tmpImage.image];
        [scrollView addSubview:view];
        [view release];
    }
    [self setSelectedViewForIndex:selectedIndex];
}

- (void)setSelectedViewForIndex:(NSInteger)_index{
    for (int i = 0; i<[self.list count]; i++) {
        UIView *view = [scrollView viewWithTag:kIconViewTag+i];
        UIImageView *imageView = (UIImageView*)[view viewWithTag:kIconImageTag];
        if (i != _index) {
            [imageView setAlpha:0.6];
        }else {
            [imageView setAlpha:1.0];
        }
    }
    [scrollView setContentOffset:CGPointMake(_index*iconWidth, 0) animated:YES];
    [self setCategoryName];
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
    	
	// Go back
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	[self performSelector:@selector(actionDoneComplete) withObject:nil afterDelay:0.2];
}

- (void)actionDoneComplete {
	
	// Change tab
    if (btype == BillTypeAdd) {
        [[AppDelegate shared].tabBarController setSelectedIndex:0];
        [[AppDelegate shared].tabBarController animationTransactionAdding:transaction];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
}

- (IBAction)actionDate:(id)sender {
	PickerDateViewController *controller = [MainController getViewController:@"PickerDateViewController"];
	[controller setValue:transaction.date];
	[controller setParent:self];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionRecurring:(id)sender {
	AddPickerViewController *controller = [MainController getViewController:@"AddPickerViewController"];
	
    if (transaction.repeatType < 0 || transaction.repeatValue < 0) {
        [controller setValue:[NSNumber numberWithInt:transaction.repeatValue]];
        [controller setPickerType:PickerTypeDontRepeat];
    }else {
        [controller setValue:[NSNumber numberWithInt:transaction.repeatValue]];
        [controller setPickerType:transaction.repeatType];
    }    
		
	
	[controller setParent:self];
	[[RootViewController shared] presentModalViewController:controller animated:YES];
}

- (IBAction)actionButtonPageLeft:(UIButton *)sender {
	selectedIndex = (selectedIndex-1+[self.list count])%[self.list count];
    [self setSelectedViewForIndex:selectedIndex];
}

- (IBAction)actionClearText:(id)sender{
    textView.text = @"";
    buttonClearText.hidden = YES;
}

- (IBAction)actionButtonPageRight:(UIButton *)sender {
    selectedIndex = (selectedIndex+1)%[self.list count];
    [self setSelectedViewForIndex:selectedIndex];
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

- (void)textChanged:(NSNotification*)notification{
    if (textView && buttonClearText) {
        if ([textView.text isEqualToString:@""]) {
            buttonClearText.hidden = YES;
        }else {
            buttonClearText.hidden = NO;
        }
    }
}


- (void)actionEditPrice:(UITapGestureRecognizer*)sender{
    CalculatorViewController *controller = [MainController getViewController:@"CalculatorViewController"];
	[controller setParent:self];
	[controller setSelectorBack:@selector(setPrice:)];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

-(void)actionScrollTap:(UITapGestureRecognizer*)sender{
    UIView *view = sender.view;
    selectedIndex = view.tag-kIconViewTag;
    [self setSelectedViewForIndex:selectedIndex];
}

-(void)actionBack{
    if (btype == BillTypeAdd) {
        // Set selected category
        Categories *c = [self.list objectAtIndex:selectedIndex];
        transaction.categoriesId = c.Id;
        transaction.categoriesParentId = c.parentId;
        
        // Set desc
        transaction.desc = textView.text;
        [[NSUserDefaults standardUserDefaults] setObject:[transaction asDict]forKey:@"saved_transaction"];
    }
    [super actionBack];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	// Set price
	[labelPrice setText:[transaction price]];
	
	// Set date
	[buttonDate setTitle:[transaction.date dateFormat:NSLocalizedString(@"add_bill_date_format", @"")] forState:UIControlStateNormal];
	
	// Set recurring
	[labelRecurring setText:transaction.repeatName];
}

- (void)setPrice:(NSNumber*)price{
    transaction.amount = [price floatValue];
    [labelPrice setText:[transaction price]];
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
        [labelName setFrame:CGRectMake(roundf(self.view.frame.size.width / 2-labelName.frame.size.width / 2), roundf(imageViewName.center.y-labelName.frame.size.height / 2-1), labelName.frame.size.width, labelName.frame.size.height)];
		
		// Change image background name rect and center
		r = imageViewName.frame;
		r.size.width = labelName.frame.size.width + 14.0f;
		imageViewName.frame = r;
		
		[imageViewName setCenter:CGPointMake(self.view.frame.size.width / 2, imageViewName.center.y)];
        [imageViewName setFrame:CGRectMake(roundf(self.view.frame.size.width / 2 - imageViewName.frame.size.width / 2), imageViewName.frame.origin.y, imageViewName.frame.size.width, imageViewName.frame.size.height)];
		
		[UIView animateWithDuration:0.2f animations:^{
			[labelName setAlpha:1.0f];
			[imageViewName setAlpha:1.0f];
		}];
	}];
}

#pragma mark -
#pragma mark ISScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self updateSelectedIndex];
        [self setSelectedViewForIndex:selectedIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateSelectedIndex];
    [self setSelectedViewForIndex:selectedIndex];
}

- (void)updateSelectedIndex{
    NSInteger cIndex = (NSInteger)(scrollView.contentOffset.x/iconWidth);
    CGFloat diff  = scrollView.contentOffset.x/iconWidth-cIndex;
    if (diff > 0.5) {
        cIndex++;
    }
    selectedIndex = cIndex;
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
    [buttonClearText release];
    buttonClearText = nil;
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
    [buttonClearText release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end