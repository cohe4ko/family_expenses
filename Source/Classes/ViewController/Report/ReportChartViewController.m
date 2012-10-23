//
//  ReportChartViewController.m
//  Expenses
//

#import "ReportChartViewController.h"

#import "ReportBox.h"
#import "TransactionsController.h"
#import "OrdinalNumberFormatter.h"
#import "ReportDateFilterViewController.h"
#import "NSDate+Utils.h"
#import "NSDate+DateFunctions.h"
#import "SettingsController.h"
#import "CategoriesController.h"
#import "ReportLinearItem.h"

#define kChartLeftBound -5000.0f
#define kChartBottomBound 0.0f
#define kChartMinScale 1.0
#define kChartMaxScale 4.0

@interface ReportChartViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)setData;

- (NSString*)dateFormatForDictKey;
- (NSString*)xAxisFormat;
- (NSInteger)xAxisElementsCount;
- (CGFloat)xAxisElementForIndex:(NSInteger)dateIndex;
- (NSInteger)numberOfDaysOnScreen;
@end

@interface ReportChartViewController ()
@property (nonatomic, retain) NSDictionary *chart;
@property (nonatomic, retain) NSArray *boxArray;
@end

@implementation ReportChartViewController
@synthesize chart, boxArray,
dateFrom, dateTo, scrollView,labelLowData,buttonDateRange,groupType;

@synthesize reportViewBox = viewBox;
@synthesize draggableViewController;


#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
    [self.view addSubview:draggableController.view];
    CGRect f = draggableController.view.frame;
    draggableController.autocloseInterval = 5.0f;
    draggableController.useAutoclose = YES;
    f.origin.y = self.view.frame.size.height - draggableController.draggableHeaderView.frame.size.height + 8.0f;
	draggableController.view.frame = f;
}

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation{
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.draggableViewController.draggableHeaderView.hidden = NO;
        viewBox.hidden = NO;
        self.draggableViewController.draggableCloseHeaderView.hidden = NO;
        buttonDateRange.hidden = NO;
        labelHint.hidden = NO;
        imageViewBg.frame = CGRectMake(0, 6, 320, 352);
        scrollView.frame = CGRectMake(5, 60, 320, 287);
        scrollView.contentSize = CGSizeMake(320, 287);
        if (hostingView) {
            hostingView.frame = CGRectMake(0, 0, 320, 287);
        }
    }else {
        self.draggableViewController.draggableHeaderView.hidden = YES;
        self.draggableViewController.draggableCloseHeaderView.hidden = YES;
        viewBox.hidden = YES;
        buttonDateRange.hidden = YES;
        labelHint.hidden = YES;
        imageViewBg.frame = CGRectMake(0, 0, 480, 300);
        scrollView.frame = CGRectMake(0, 10, 480, 300);
        scrollView.contentSize = CGSizeMake(480, 300);
        if (hostingView) {
            hostingView.frame = CGRectMake(0, 0, 480, 300);
        }
    }
}

#pragma mark -
#pragma mark Set


- (void)setData {

    if (self.boxArray) {
        NSMutableArray *boxItemsArray = [NSMutableArray array];
        for(NSDictionary *dbBoxItem in self.boxArray)
        {
            NSNumber *amount = [dbBoxItem objectForKey:@"amount"];
            NSNumber *categoryId = [dbBoxItem objectForKey:@"category"];
            if (amount && categoryId && [amount doubleValue] > 0) {
                Categories *category = [CategoriesController getById:[categoryId intValue]];
                NSDictionary *boxItem = [NSDictionary dictionaryWithObjectsAndKeys:[category name], @"name", amount, @"amount", [Categories colorStringForCategiryId:[categoryId intValue]], @"color", nil];
                [boxItemsArray addObject:[ReportBox withDictionary:boxItem]];
            }
        }
        [viewBox setList:boxItemsArray];
    }
    
	
}
#pragma mark -
#pragma mark Make

- (void)makeLocales {
	NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    self.dateFrom = beginDate;
    self.dateTo = endDate;
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ - %@",[beginDate dateFormat:NSLocalizedString(@"report_date_format", @"")],[endDate dateFormat:NSLocalizedString(@"report_date_format", @"")]];
    [buttonDateRange setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)makeItems {

}


-(void) setValues:(NSDictionary*)values forBoxData:(NSArray*)boxData forMaxAmount:(CGFloat)maxAmount{
    self.chart = values;
    self.boxArray = boxData;
    [self setData];
    
   
    NSTimeInterval minDate = [self.dateFrom timeIntervalSince1970];
    
    CGFloat wd = scrollView.frame.size.width;
    CGFloat dh = scrollView.frame.size.height;
    scrollView.delaysContentTouches = YES;
    
    CGFloat offsetX = 0;
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    
    if (hostingView) {
        [hostingView removeFromSuperview];
    }
    
    hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(offsetX,0,wd, dh)];
    offsetX += wd;
    hostingView.tag = 1010;
    
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    
    graph.plotAreaFrame.paddingLeft   = 50.0;
    graph.plotAreaFrame.paddingTop    = 10.0;
    graph.plotAreaFrame.paddingRight  = 0;
    graph.plotAreaFrame.paddingBottom = 50.0;
        
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = graph;        
    [scrollView addSubview:hostingView];
    [graph release];
    
    [hostingView release];

    //        NSUInteger catSize = [[categories objectForKey:catNum] count];
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval minX       = minDate;
    NSTimeInterval maxX       = minX + oneDay * [self numberOfDaysOnScreen]; // one week on screen
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(kChartLeftBound) length:CPTDecimalFromFloat(maxX - minX)];
    plotSpace.allowsUserInteraction = YES;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(kChartBottomBound) length:CPTDecimalFromFloat(maxAmount-2*kChartBottomBound)];
    plotSpace.delegate = self;
    currentScale = 1.0;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.6] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *yGridLineStyle = [CPTMutableLineStyle lineStyle];
    yGridLineStyle.lineWidth = 1.0;
    yGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.6] colorWithAlphaComponent:0.75];
    yGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:4],nil];
    yGridLineStyle.patternPhase = 0.0;
    
    
    // label style
    CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.fontSize = 8.0f;
    labelStyle.color = [[CPTColor colorWithGenericGray:0.6] colorWithAlphaComponent:0.75];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = majorGridLineStyle;
    x.majorTickLineStyle = nil;
    x.majorGridLineStyle = yGridLineStyle;
    x.minorTicksPerInterval       = 0;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = [self xAxisFormat];
   
    //        dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    
    timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSince1970:minX];
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = labelStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    
    NSMutableSet *xMajorLocations = [NSMutableSet set];
    
    for (int i = 0; i < [self xAxisElementsCount]; i++) {
        CGFloat location = [self xAxisElementForIndex:i];
        [xMajorLocations addObject:[NSNumber numberWithFloat:location]];
    }
    
    x.majorTickLocations = xMajorLocations;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromFloat(maxAmount / 7.0f);
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTicksPerInterval       = 0;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorTicksPerInterval       = 0;
    y.labelTextStyle = labelStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    OrdinalNumberFormatter* yLabelFormatter = [[[OrdinalNumberFormatter alloc] init] autorelease];
    
    y.labelFormatter = yLabelFormatter;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    

    // flow parent categories
    for(NSDictionary *dbBoxItem in self.boxArray)
    {
        // create graph view
        NSNumber *categoryId = [dbBoxItem objectForKey:@"category"];
        
        if (categoryId) {
            // Create plot area
            CPTScatterPlot *boundLinePlot  = [[[CPTScatterPlot alloc] init] autorelease];
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.miterLimit        = 1.0f;
            lineStyle.lineWidth         = 1.0f;
            lineStyle.lineColor         = [CPTColor colorWithCGColor:[UIColor colorWithHexString:[Categories colorStringForCategiryId:[categoryId integerValue]]].CGColor];
            boundLinePlot.dataLineStyle = lineStyle;
            boundLinePlot.dataSource    = self;
            boundLinePlot.identifier = categoryId;
            
            CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
            plotSymbol.lineStyle = lineStyle;
            plotSymbol.fill = [[[CPTFill alloc] initWithColor:[CPTColor whiteColor]] autorelease];
            plotSymbol.size               = CGSizeMake(5.0, 5.0);
            boundLinePlot.plotSymbol = plotSymbol;
            [graph addPlot:boundLinePlot];
        }
        
    }
    
    graph.rasterizationScale = [UIScreen mainScreen].scale;
    graph.shouldRasterize = YES;
    
    scrollView.contentSize = CGSizeMake(offsetX, dh);
            
    [self makeLocales];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDateRange:(id)sender {
    ReportDateFilterViewController *reportDateRangeViewController = [[ReportDateFilterViewController alloc] initWithNibName:@"TransactionGroupViewController_iPhone" bundle:nil];
    [[RootViewController shared] presentModalViewController:reportDateRangeViewController animated:YES];
    [reportDateRangeViewController release];
}



#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self xAxisElementsCount];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    id key = plot.identifier;
    
    if(!fieldEnum)
    {
        NSTimeInterval tm = [self xAxisElementForIndex:_index];
        return [NSNumber numberWithFloat:tm];
    }
    NSDate *currDate = [NSDate dateWithTimeInterval:[self xAxisElementForIndex:_index] sinceDate:dateFrom];
    CGFloat amount = 0.0;
    for (NSDictionary *boxItem in boxArray) {
        NSNumber *categoryId = [boxItem objectForKey:@"category"];
        if (categoryId && [categoryId integerValue] <= [key integerValue]) {
            NSString *dictKey = [NSString stringWithFormat:@"%@_%@",[currDate dateFormat:[self dateFormatForDictKey]],categoryId];
            if ([self.chart objectForKey:dictKey]) {
                ReportLinearItem *item = [self.chart objectForKey:dictKey];
                amount += item.amount;
            }
        }
    }
    
    return [NSNumber numberWithFloat:amount];

}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{

    return NO;
}

#pragma mark -
#pragma mark CPTPlotSpaceDelegate

-(CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement {
    return CGPointMake(displacement.x, 0);
}

- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space
      willChangePlotRangeTo:(CPTPlotRange *)newRange
              forCoordinate:(CPTCoordinate)coordinate {
    
    CPTPlotRange *updatedRange = nil;
    
    switch ( coordinate ) {
        case CPTCoordinateX:
            if (newRange.locationDouble < kChartLeftBound) {
                CPTMutablePlotRange *mutableRange = [[newRange mutableCopy] autorelease];
                mutableRange.location = CPTDecimalFromFloat(kChartLeftBound);
                updatedRange = mutableRange;
            }
            else if (newRange.locationDouble+newRange.lengthDouble > [dateTo timeIntervalSinceDate:dateFrom]) {
                CPTMutablePlotRange *mutableRange = [[newRange mutableCopy] autorelease];
                
                if ([dateTo timeIntervalSinceDate:dateFrom] - newRange.lengthDouble > kChartLeftBound) {
                    mutableRange.location = CPTDecimalFromCGFloat([dateTo timeIntervalSinceDate:dateFrom] - newRange.lengthDouble);
                }else{
                    mutableRange.location = CPTDecimalFromCGFloat(kChartLeftBound);
                }
                
                updatedRange = mutableRange;
            }else{
                updatedRange = newRange;
            }
            break;
        case CPTCoordinateY:
            updatedRange = ((CPTXYPlotSpace *)space).yRange;
            break;
            
        default:
            break;
    }
    return updatedRange;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint{
    if (interactionScale*currentScale < kChartMinScale || interactionScale*currentScale > kChartMaxScale) {
        return NO;
    }
    currentScale = interactionScale*currentScale;
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point

{
    if([event.allTouches count] > 1)
        return NO;
    
    return YES;
}
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    if([event.allTouches count] > 1)
        return NO;
    
    return YES;
    
}

#pragma mark - Private

- (NSString*)dateFormatForDictKey{
    switch (self.groupType) {
        case GroupDay:
            return @"YYYYMMdd";
            break;
        case GroupWeek:
            return @"YYYYMMww";
            break;
        case GroupMonth:
            return @"YYYYMM";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString*)xAxisFormat{
    switch (self.groupType) {
        case GroupDay:
            return @"dd MMM YYYY";
            break;
        case GroupWeek:
            return @"ww MMM YYYY";
            break;
        case GroupMonth:
            return @"MMM YYYY";
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)xAxisElementsCount{
    switch (self.groupType) {
        case GroupDay:
            return [NSDate daysBetweenDates:self.dateFrom ToDate:self.dateTo];
            break;
        case GroupWeek:
            break;
        case GroupMonth:{
            NSInteger dateElement1 = [self.dateFrom year]*12+[self.dateFrom month];
            NSInteger dateElement2 = [self.dateTo year]*12+[self.dateTo month];
            return dateElement2-dateElement1+1;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat)xAxisElementForIndex:(NSInteger)dateIndex{
    switch (self.groupType) {
        case GroupDay:
            return [[self.dateFrom addDays:dateIndex] timeIntervalSinceDate:self.dateFrom];
            break;
        case GroupWeek:
            break;
        case GroupMonth:
            return [[self.dateFrom addMonths:dateIndex] timeIntervalSinceDate:self.dateFrom];
            break;
        default:
            break;
    }
    return 0.0;
}

- (NSInteger)numberOfDaysOnScreen{
    switch (self.groupType) {
        case GroupDay:
            return 4;
            break;
        case GroupWeek:
            return 7;
            break;
        case GroupMonth:
            return 90;
            break;
            
        default:
            break;
    }
    return 4;
}


#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[labelHint release];
	labelHint = nil;
	[viewBox release];
	viewBox = nil;
    [buttonDateRange release];
    buttonDateRange = nil;
    [scrollView release];
    scrollView = nil;
    [imageViewBg release];
    imageViewBg = nil;
	[super viewDidUnload];
}

- (void)dealloc {
    self.chart = nil;
    self.boxArray = nil;
    [dateFrom release];
    [dateTo release];
	[labelHint release];
	[viewBox release];
    [buttonDateRange release];
    [scrollView release];
    [imageViewBg release];
    [super dealloc];
}

@end