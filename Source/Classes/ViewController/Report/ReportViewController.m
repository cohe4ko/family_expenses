//
//  ReportViewController.m
//  Expenses
//

#import "ReportViewController.h"
#import "TransactionsController.h"
#import "CategoriesController.h"
#import "Transactions.h"

@interface ReportViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation ReportViewController

@synthesize diagramViewController, chartViewController;

#pragma mark -
#pragma mark Initializate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(actionDateChangedNotification:) name:NOTIFICATION_REPORT_UPDATE object:nil];
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
    
//    [self setData];
}

-(void) viewWillAppear:(BOOL)animated{
    [self actionDateChangedNotification:nil];
}
#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Make segment
	UIView *viewSegment = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)] autorelease];
	[viewSegment setBackgroundColor:[UIColor clearColor]];
	
	// Make segment button left
	buttonSegmentLeft = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
	[[buttonSegmentLeft titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
	[[buttonSegmentLeft titleLabel] setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
	[[buttonSegmentLeft titleLabel] setShadowOffset:CGSizeMake(0.0f, -0.7f)];
	[buttonSegmentLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[buttonSegmentLeft setBackgroundImage:[[UIImage imageNamed:@"segmented_left-active.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	[buttonSegmentLeft setTitle:NSLocalizedString(@"report_segmented_diagram", @"Login") forState:UIControlStateNormal];
	[buttonSegmentLeft addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventTouchUpInside];
	[viewSegment addSubview:buttonSegmentLeft];
	
	// Make segment button right
	buttonSegmentRight = [[UIButton alloc] initWithFrame:CGRectMake(100.0f, 0.0f, 100.0f, 30.0f)];
	[[buttonSegmentRight titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
	[[buttonSegmentRight titleLabel] setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
	[[buttonSegmentRight titleLabel] setShadowOffset:CGSizeMake(0.0f, -0.7f)];
	[buttonSegmentRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[buttonSegmentRight setBackgroundImage:[[UIImage imageNamed:@"segmented_right.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	[buttonSegmentRight setTitle:NSLocalizedString(@"report_segmented_chart", @"Signup") forState:UIControlStateNormal];
	[buttonSegmentRight addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventTouchUpInside];
	[viewSegment addSubview:buttonSegmentRight];
	
	segmentedState = SegmentedLeft;
	
	[self.navigationItem setTitleView:viewSegment];
	
	// Set button print
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_print.png"] withSelector:@selector(actionPrint)];
	
}

- (void)makeLocales {
	
}

- (void)makeItems {
	
	CGRect r;
	
	// Init controllers
	self.diagramViewController = [MainController getViewController:@"ReportDiagramViewController"];
	[self.view addSubview:self.diagramViewController.view];
	
	self.chartViewController = [MainController getViewController:@"ReportChartViewController"];
	[self.view addSubview:self.chartViewController.view];
	r = self.chartViewController.view.frame;
	r.origin.x = self.view.frame.size.width;
	self.chartViewController.view.frame = r;
	
}

#pragma mark -
#pragma mark Actions

- (void)actionPrint {
	
}

- (void)actionSegment:(UIButton *)button {
	      
	segmentedState = (button == buttonSegmentLeft) ? SegmentedLeft : SegmentedRight;
	
	[buttonSegmentLeft setBackgroundImage:[[UIImage imageNamed:((segmentedState == SegmentedLeft) ? @"segmented_left-active.png" : @"segmented_left.png")] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	[buttonSegmentRight setBackgroundImage:[[UIImage imageNamed:((segmentedState == SegmentedRight) ? @"segmented_right-active.png" : @"segmented_right.png")] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	
	[UIView animateWithDuration:0.4f animations:^{
		CGRect r = self.diagramViewController.view.frame;
		r.origin.x = (segmentedState == SegmentedLeft) ? 0.0f : -self.view.frame.size.width;
		self.diagramViewController.view.frame = r;
		
		r = self.chartViewController.view.frame;
		r.origin.x = (segmentedState == SegmentedRight) ? 0.0f : self.view.frame.size.width;
		self.chartViewController.view.frame = r;
	} completion:^(BOOL finished) {}];
}

- (void)actionDateChangedNotification:(NSNotification*)notification{
    [self.view bringSubviewToFront:loadingView];
    [loadingView startAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    diagramViewController.scrollView.hidden = YES;
    diagramViewController.labelLowData.hidden = YES;
    chartViewController.scrollView.hidden = YES;
    chartViewController.labelLowData.hidden = YES;
    
    
    [self performSelector:@selector(setData) withObject:nil afterDelay:0.25f];
}

#pragma mark -
#pragma mark Set

- (void)setData {
    
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_begin_date"];
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"graph_filter_end_date"];
    if (!beginDate) {
        beginDate = [TransactionsController minumDate];
        [[NSUserDefaults standardUserDefaults] setObject:beginDate forKey:@"graph_filter_begin_date"];
    }
    if (!endDate) {
        endDate = [TransactionsController maximumDate];
        [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"graph_filter_end_date"];
    }
    
    NSArray *values = [TransactionsController loadTransactions:SortDate minDate:beginDate maxDate:endDate];

    NSMutableDictionary *chartByDay = nil;
    if (values) {
        chartByDay = [NSMutableDictionary dictionary];
        for (Transactions *t in values) {
            
            NSMutableDictionary *catDic = [chartByDay objectForKey:[NSNumber numberWithInt:t.categoriesParentId]];
            if(!catDic) {
                catDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0],@"total",[NSMutableDictionary dictionary],@"subCat",[NSNumber numberWithInt:t.categoriesParentId],@"cid", nil];
                Categories *c = [CategoriesController getById:t.categoriesParentId];
                if (c && c.name) {
                    [catDic setObject:c.name forKey:@"name"];
                }
            }
            NSNumber *total = [catDic objectForKey:@"total"];
            [catDic setObject:[NSNumber numberWithDouble:[total doubleValue]+t.amount] forKey:@"total"];
            
            //update subcategory
            NSMutableDictionary *subCat = [catDic objectForKey:@"subCat"];
            NSMutableDictionary *subCatDic = [subCat objectForKey:[NSNumber numberWithInt:t.categoriesId]];
            if (!subCatDic) {
                subCatDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0],@"total",[NSNumber numberWithInt:t.categoriesId],@"cid", nil];
                Categories *c = [CategoriesController getById:t.categoriesId];
                if (c && c.name) {
                    [subCatDic setObject:c.name forKey:@"name"];
                }
            }
            total = [subCatDic objectForKey:@"total"];
            [subCatDic setObject:[NSNumber numberWithDouble:[total doubleValue]+t.amount] forKey:@"total"];
            [subCat setObject:subCatDic forKey:[NSNumber numberWithInt:t.categoriesId]];
            [catDic setObject:subCat forKey:@"subCat"];
            [chartByDay setObject:catDic forKey:[NSNumber numberWithInt:t.categoriesParentId]];
        }
    }
    
    
    [diagramViewController setValues:values forDic:chartByDay];
    [chartViewController setValues:values forDic:chartByDay];
    
    [loadingView stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    
    if (!values || [values count] == 0) {
        diagramViewController.scrollView.hidden = YES;
        diagramViewController.labelLowData.hidden = NO;
        chartViewController.scrollView.hidden = YES;
        chartViewController.labelLowData.hidden = NO;
    }else {
        diagramViewController.scrollView.hidden = NO;
        diagramViewController.labelLowData.hidden = YES;
        chartViewController.scrollView.hidden = NO;
        chartViewController.labelLowData.hidden = YES;
    }
    
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
        
    [diagramViewController renderToInterfaceOrientation:toInterfaceOrientation];
    [chartViewController renderToInterfaceOrientation:toInterfaceOrientation];
    if(segmentedState == SegmentedLeft){
        [self actionSegment:buttonSegmentLeft];
    }else {
        [self actionSegment:buttonSegmentRight];
    }
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[diagramViewController release];
	[chartViewController release];
    [loadingView release];
    [super dealloc];
}

@end