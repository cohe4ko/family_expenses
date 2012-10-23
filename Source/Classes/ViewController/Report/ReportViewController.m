//
//  ReportViewController.m
//  Expenses
//

#import "ReportViewController.h"
#import "ReportController.h"
#import "CategoriesController.h"
#import "ReportCategoryPieItem.h"
#import "ReportSubcategoryPieItem.h"
#import "ReportLinearItem.h"
#import "SettingsController.h"

@interface ReportViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
- (void)cleanView;
- (void)makeGroupButton;

- (NSDictionary*)updateLinearGraphic;
- (NSDictionary*)updatePieGraphic;

- (void)setLinearGraphicData:(NSDictionary*)data;
- (void)setPieGraphicData:(NSDictionary*)data;

- (void)startLoading;
- (void)stopLoading;
@end

@implementation ReportViewController
@synthesize groupType,isGroup;

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
	[self makeGroupButton];
	
}

- (void)makeGroupButton{
    if (segmentedState == SegmentedLeft) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        [self setButtonLeftWithImage:[UIImage imageNamed:@"icon_group.png"] withSelector:@selector(actionGroup)];
    }
}

- (void)makeLocales {
    [labelGroupHeader setText:NSLocalizedString(@"transactions_group_header", @"")];
    [buttonGroupDay setTitle:NSLocalizedString(@"transactions_group_by_day", @"") forState:UIControlStateNormal];
	[buttonGroupWeek setTitle:NSLocalizedString(@"transactions_group_by_week", @"") forState:UIControlStateNormal];
	[buttonGroupMonth setTitle:NSLocalizedString(@"transactions_group_by_month", @"") forState:UIControlStateNormal];
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
    
    [buttonGroupDay setTag:GroupDay];
    [buttonGroupWeek setTag:GroupWeek];
    [buttonGroupMonth setTag:GroupMonth];
    
    groupType = -1;
    self.groupType = [[NSUserDefaults standardUserDefaults] integerForKey:@"graph_group"];
}

#pragma mark -
#pragma mark Actions

- (void)actionGroup {
	self.isGroup = !self.isGroup;
}

- (IBAction)actionGroupButton:(UIButton*)sender{
    if (self.groupType != sender.tag) {
        self.groupType = sender.tag;
        [self startLoading];
        dispatch_queue_t queue = dispatch_get_global_queue(
                                                           DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSDictionary *linearGraphic = [self updateLinearGraphic];
            // tell the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setLinearGraphicData:linearGraphic];
                [self stopLoading];
            });
        });
    }

}

- (IBAction)actionGroupTap {
    self.isGroup = !self.isGroup;
}

- (void)actionSegment:(UIButton *)button {
	      
	segmentedState = (button == buttonSegmentLeft) ? SegmentedLeft : SegmentedRight;
	
	[buttonSegmentLeft setBackgroundImage:[[UIImage imageNamed:((segmentedState == SegmentedLeft) ? @"segmented_left-active.png" : @"segmented_left.png")] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	[buttonSegmentRight setBackgroundImage:[[UIImage imageNamed:((segmentedState == SegmentedRight) ? @"segmented_right-active.png" : @"segmented_right.png")] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f] forState:UIControlStateNormal];
	
    [self makeGroupButton];
    
	[UIView animateWithDuration:0.4f animations:^{
		CGRect r = self.diagramViewController.view.frame;
		r.origin.x = (segmentedState == SegmentedLeft) ? 0.0f : -self.view.frame.size.width;
		self.diagramViewController.view.frame = r;
		
		r = self.chartViewController.view.frame;
		r.origin.x = (segmentedState == SegmentedRight) ? 0.0f : self.view.frame.size.width;
		self.chartViewController.view.frame = r;
	} completion:^(BOOL finished) {
        
    }];
}

- (void)actionDateChangedNotification:(NSNotification*)notification{
    [self setData];
}


#pragma mark -
#pragma mark Set

- (void)setData {
    [self startLoading];
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDictionary *pieData = [self updatePieGraphic];
        NSDictionary *linearGraphic = [self updateLinearGraphic];
        // tell the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPieGraphicData:pieData];
            [self setLinearGraphicData:linearGraphic];
            [self stopLoading];
        });
    });
    
}

- (void)setGroupType:(GroupType)_groupType{
    if (groupType != _groupType) {
		groupType = _groupType;
		
		// Set sort buttons image
		[buttonGroupDay setImage:((groupType == GroupDay) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonGroupWeek setImage:((groupType == GroupWeek) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
		[buttonGroupMonth setImage:((groupType == GroupMonth) ? [UIImage imageNamed:@"radio_checked.png"] : [UIImage imageNamed:@"radio.png"]) forState:UIControlStateNormal];
        
  				
		// Hide group
		self.isGroup = NO;
		
		// Save group
		[[NSUserDefaults standardUserDefaults] setInteger:groupType forKey:@"graph_group"];
		[[NSUserDefaults standardUserDefaults] synchronize];
       
	}
}

- (void)setIsGroup:(BOOL)_isGroup{
    if (isGroup != _isGroup) {
		isGroup = _isGroup;
    		
        if (isGroup) {
            [[[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController] view] addSubview:viewGroup];
            [UIView animateWithDuration:0.3 animations:^{
                viewGroup.alpha = 1.0;
            } completion:^(BOOL finished){
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                viewGroup.alpha = 0.0;
            } completion:^(BOOL finished){
                [viewGroup removeFromSuperview];
            }];
        }
        
	}
}

#pragma mark - Loading

- (void)startLoading{
    [self.view bringSubviewToFront:loadingView];
    [loadingView startAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    diagramViewController.scrollView.hidden = YES;
    diagramViewController.labelLowData.hidden = YES;
    chartViewController.scrollView.hidden = YES;
    chartViewController.labelLowData.hidden = YES;
}

- (void)stopLoading{
    diagramViewController.scrollView.hidden = NO;
    chartViewController.scrollView.hidden = NO;
    [loadingView stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:loadingView];
}

#pragma mark - Update

- (NSDictionary*)updateLinearGraphic{
    NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    NSDictionary *linerGraphicDict = [ReportController loadTransactionsForLinearGraphic:self.groupType minDate:beginDate maxDate:endDate];
    NSArray *boxData = [ReportController loadDataForReportBoxForMinDate:beginDate maxDate:endDate];
    CGFloat maxAmount = [ReportController maxAmountForLinearGraphicForGroup:self.groupType minDate:beginDate maxDate:endDate];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:linerGraphicDict,@"chart",boxData,@"box",[NSNumber numberWithDouble:maxAmount],@"maxAmount", nil];
}

- (NSDictionary*)updatePieGraphic{
    NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    NSArray *categoriesArray = [ReportController loadTransactionsForPieGraphicWithCategoriesForMinDate:beginDate maxDate:endDate];
    
    NSArray *subcategoriesArray = [ReportController loadTransactionsForPieGraphicWithSubcategoriesForMinDate:beginDate maxDate:endDate];
    
    NSMutableDictionary *groupedByParentCategories = [NSMutableDictionary dictionary];
    
    for (ReportCategoryPieItem *categoryPieItem in categoriesArray) {
        NSNumber *categoryNum = [NSNumber numberWithInt:categoryPieItem.categoriesId];
        NSMutableArray *groupArr = [NSMutableArray array];
        for (ReportSubcategoryPieItem *subcategoryPieItem in subcategoriesArray) {
            if (subcategoryPieItem.categoriesParentId == categoryPieItem.categoriesId) {
                [groupArr addObject:subcategoryPieItem];
            }
        }
        [groupedByParentCategories setObject:groupArr forKey:categoryNum];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:categoriesArray,@"categories",subcategoriesArray,@"subcategories",groupedByParentCategories,@"groupDict", nil];
}

- (void)setLinearGraphicData:(NSDictionary*)data{
    NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    NSDictionary *linerGraphicDict = [data objectForKey:@"chart"];
    NSArray *boxData = [data objectForKey:@"box"];
    CGFloat maxAmount = [[data objectForKey:@"maxAmount"] doubleValue];
    
    chartViewController.dateFrom = beginDate;
    chartViewController.dateTo = endDate;
    chartViewController.groupType = self.groupType;
    
    [chartViewController setValues:linerGraphicDict forBoxData:boxData forMaxAmount:maxAmount];
    
    if (!linerGraphicDict || [linerGraphicDict count] == 0 || maxAmount <= 0) {
        chartViewController.scrollView.hidden = YES;
        chartViewController.labelLowData.hidden = NO;
    }else {
        chartViewController.scrollView.hidden = NO;
        chartViewController.labelLowData.hidden = YES;
    }
}

- (void)setPieGraphicData:(NSDictionary*)data{
    NSArray *categoriesArray = [data objectForKey:@"categories"];
    NSArray *subcategoriesArray = [data objectForKey:@"subcategories"];
    NSMutableDictionary *groupedByParentCategories = [data objectForKey:@"groupDict"];
    
    [diagramViewController setValuesForCategoryGrouped:categoriesArray subcategoryGrouped:subcategoriesArray subcatGroupedByCat:groupedByParentCategories];
    
    if (!categoriesArray || [categoriesArray count] == 0) {
        diagramViewController.scrollView.hidden = YES;
        diagramViewController.pageControl.hidden = YES;
        diagramViewController.labelLowData.hidden = NO;
    }else {
        diagramViewController.scrollView.hidden = NO;
        diagramViewController.pageControl.hidden = NO;
        diagramViewController.labelLowData.hidden = YES;
    }
}

#pragma mark - Gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


#pragma mark - Other

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

- (void)cleanView{
    if (loadingView) {
        [loadingView release];
        loadingView = nil;
    }
    if (viewGroup) {
        [viewGroup release];
        viewGroup = nil;
    }
    if (buttonGroupDay) {
        [buttonGroupDay release];
        buttonGroupDay = nil;
    }
    if (buttonGroupMonth) {
        [buttonGroupMonth release];
        buttonGroupMonth = nil;
    }
    if (buttonGroupWeek) {
        [buttonGroupWeek release];
        buttonGroupWeek = nil;
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [self cleanView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[diagramViewController release];
	[chartViewController release];
    [self cleanView];
    [super dealloc];
}

@end