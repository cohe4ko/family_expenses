//
//  ReportViewController.m
//  Expenses
//

#import "ReportViewController.h"
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

-(void) viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:loadingView];
    [loadingView startAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    diagramViewController.scrollView.hidden = YES;
    chartViewController.scrollView.hidden = YES;
    
    [self performSelector:@selector(setData) withObject:nil afterDelay:0.25f];
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

#pragma mark -
#pragma mark Set

- (void)setData {
 	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Transactions WHERE state = %d ORDER BY time", TransactionsStateNormal];
	NSArray* values = [[[Db shared] loadAndFill:sql theClass:[Transactions class]] mutableCopy];

    [diagramViewController setValues:values];
    [chartViewController setValues:values];
    
    [loadingView stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    diagramViewController.scrollView.hidden = NO;
    chartViewController.scrollView.hidden = NO;
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[diagramViewController release];
	[chartViewController release];
    [loadingView release];
    [super dealloc];
}

@end