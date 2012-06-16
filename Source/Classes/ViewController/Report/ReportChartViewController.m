//
//  ReportChartViewController.m
//  Expenses
//

#import "ReportChartViewController.h"

#import "ReportBox.h"
#import "DraggableViewController.h"

#import "TransactionsController.h"
#import "OrdinalNumberFormatter.h"

@interface ReportChartViewController (Private)
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation ReportChartViewController

@synthesize values, categories, minDates, maxDates, chartByDay
, chartByWeek, chartByMonth, dateFrom, dateTo;

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

#pragma mark -
#pragma mark Set

-(NSDictionary*)curentChart
{
    NSDictionary* chartData = nil;
    
    switch (currentChart) {
        case 0:
            chartData = chartByDay;
            break;
        case 1:
            chartData = chartByWeek;
            break;
        case 2:
            chartData = chartByMonth;
            break;
            
        default:
            break;
    }
    return chartData;
}

- (void)setData {
    
    // repleace with setters
    self.dateFrom = [NSDate dateFromString:@"01-01-2012"];
    self.dateTo = [NSDate dateFromString:@"31-12-2012"];
	
    // Get transactions by day
	NSMutableDictionary *d = [TransactionsController transactionsChartBy:TransactionsDay fromDate:[NSDate dateStringToDate:@"01-01-2012" dateFormat:@"dd-MM-yyyy"] toDate:[NSDate dateStringToDate:@"31-12-2012" dateFormat:@"dd-MM-yyyy"] parentCid:0];
	//NSLog(@"day - %@", d);
    
    self.chartByDay = d;
    
    NSLog(@"%@", [[d objectForKey:[NSNumber numberWithInt:0]] objectForKey:@"name"]);
	
	// Get transactions by week
	NSMutableDictionary *w = [TransactionsController transactionsChartBy:TransactionsWeek fromDate:[NSDate dateStringToDate:@"01-01-2012" dateFormat:@"dd-MM-yyyy"] toDate:[NSDate dateStringToDate:@"31-12-2012" dateFormat:@"dd-MM-yyyy"] parentCid:0];
	//NSLog(@"week - %@", w);
    
    self.chartByWeek = w;
	
	// Get transactions by month
	NSMutableDictionary *m = [TransactionsController transactionsChartBy:TransactionsMonth fromDate:[NSDate dateStringToDate:@"01-01-2012" dateFormat:@"dd-MM-yyyy"] toDate:[NSDate dateStringToDate:@"31-12-2012" dateFormat:@"dd-MM-yyyy"] parentCid:0];
    //NSLog(@"month - %@", m);
    
    self.chartByMonth = m;
    
    NSDictionary* chartData = [self curentChart];
	NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(NSNumber* cid in chartData.allKeys)
    {
        NSDictionary* d = [chartData objectForKey:cid];
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[d objectForKey:@"name"], @"name", [d objectForKey:@"total"], @"amount", [Categories colorStringForCategiryId:[cid integerValue]], @"color", nil];        
        [arr addObject:[ReportBox withDictionary:d1]];
        
    }
	[viewBox setList:arr];
    [arr release];
}
#pragma mark -
#pragma mark Make

- (void)makeLocales {
	
}

- (void)makeItems {
	
}


-(void) setValues:(NSArray *)val 
{
    [val retain];
    [values release];
    values = val;
    
    [self setData];
    
    if(!charts)
        charts = [[NSMutableArray alloc] init];
    else 
    {
        for(CPTGraphHostingView* gv in charts)
            [gv removeFromSuperview];
        
        [charts removeAllObjects];
    }
    
    self.categories = [NSMutableDictionary dictionary];

    self.minDates = [NSMutableDictionary dictionary];
    self.maxDates = [NSMutableDictionary dictionary];
    
    CGFloat maxAmount = 0;
    NSTimeInterval minDate = 0;
    NSTimeInterval maxDate = 0;
    for(Transactions* tr in values)
    {
        
        
        NSNumber* n = [NSNumber numberWithInt:(!tr.categoriesParentId)?tr.categoriesId:tr.categoriesParentId];
        NSMutableArray* cat = [categories objectForKey:n];
        if(!cat)
        {
            //
            NSNumber* num = [NSNumber numberWithFloat:maxAmount];
            
            minDate = tr.time;
            maxDate = tr.time;
            
            num = [NSNumber numberWithInteger:minDate];
            [minDates setObject:num forKey:n];
            num = [NSNumber numberWithInteger:maxDate];
            [maxDates setObject:num forKey:n];
            
            
            cat = [NSMutableArray array];
            [cat addObject:tr];
            [categories setObject:cat forKey:n];
        }
        else {
            if(tr.amount > maxAmount)
            {
                maxAmount = tr.amount;
            }
            
            if(tr.time < minDate)
            {
                minDate = tr.time;
                NSNumber* num = [NSNumber numberWithInteger:minDate];
                [minDates setObject:num forKey:n];
            }
            
            if(tr.time > maxDate)
            {
                maxDate = tr.time;
                NSNumber* num = [NSNumber numberWithInteger:maxDate];
                [maxDates setObject:num forKey:n];
            }
            
            [cat addObject:tr];
        }
    }
    
    NSLog(@"%@", categories);
    
    CGFloat wd = scrollView.frame.size.width;
    CGFloat dh = scrollView.frame.size.height;
    scrollView.delaysContentTouches = YES;
    
    CGFloat offsetX = 0;
    NSTimeInterval oneDay = 24 * 60 * 60;

    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(offsetX,0,wd, dh)];
    offsetX += wd;
    
    [charts addObject:hostingView];
    
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

    NSTimeInterval minX       = minDate - oneDay;
    NSTimeInterval maxX       = minX + oneDay * 7; // one week on screen
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(maxX - minX)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(maxAmount * 1.2f)];
    plotSpace.allowsUserInteraction = YES;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(maxAmount)];
    plotSpace.delegate = self;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.6] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // label style
    CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle textStyle];
    labelStyle.fontSize = 8.0f;
    labelStyle.color = [[CPTColor colorWithGenericGray:0.6] colorWithAlphaComponent:0.75];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorGridLineStyle = nil;
    x.minorGridLineStyle = nil;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.majorIntervalLength         = CPTDecimalFromFloat(oneDay);
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.minorTicksPerInterval       = 0;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"dd MMMM";
    //        dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    
    timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSince1970:minX];
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = labelStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromFloat(maxAmount / 7.0f);
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTicksPerInterval       = 0;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.minorTicksPerInterval       = 0;
    y.labelTextStyle = labelStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    
    OrdinalNumberFormatter* yLabelFormatter = [[[OrdinalNumberFormatter alloc] init] autorelease];
    
    y.labelFormatter = yLabelFormatter;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    

    // flow parent categories
    for(NSNumber* catNum in categories.allKeys)
    {
        // create graph view
        
        
        // Create plot area
        CPTScatterPlot *boundLinePlot  = [[[CPTScatterPlot alloc] init] autorelease];
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit        = 1.0f;
        lineStyle.lineWidth         = 1.0f;
        lineStyle.lineColor         = [CPTColor colorWithCGColor:[UIColor colorWithHexString:[Categories colorStringForCategiryId:[catNum integerValue]]].CGColor];
        boundLinePlot.dataLineStyle = lineStyle;
        boundLinePlot.dataSource    = self;
        
        boundLinePlot.identifier = catNum;

        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.lineStyle = lineStyle;
        plotSymbol.fill = [[[CPTFill alloc] initWithColor:[CPTColor whiteColor]] autorelease];
        plotSymbol.size               = CGSizeMake(3.0, 3.0);
        boundLinePlot.plotSymbol = plotSymbol;
        
        [graph addPlot:boundLinePlot];
        
        
//        NSMutableArray* cat = [categories objectForKey:catNum];
//        for(Transactions* tr in cat)
//        {
//#if TARGET_IPHONE_SIMULATOR
//            NSLog(@"parentCatId = %d", tr.categoriesParentId);
//#endif        
//        }
        
        
    }
    
    scrollView.contentSize = CGSizeMake(offsetX, dh);
            
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDateRange:(id)sender {
	
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
    NSNumber* key = plot.identifier;
    NSArray* cat = [categories objectForKey:key];
    return [cat count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    NSNumber* key = plot.identifier;
    NSArray* cat = [categories objectForKey:key];
    Transactions* t = [cat objectAtIndex:_index];
  //  NSLog(@"fieldenum = %d index = %d time=%d", fieldEnum, _index, t.time);

    
    if(!fieldEnum)
    {
        NSTimeInterval tm = t.time - [[minDates objectForKey:key] integerValue];
        return [NSNumber numberWithFloat:tm];
    }
    
    return [NSNumber numberWithFloat:t.amount];
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
            if (newRange.locationDouble < 0.0F) {
                CPTMutablePlotRange *mutableRange = [[newRange mutableCopy] autorelease];
                mutableRange.location = CPTDecimalFromFloat(0.0);
                updatedRange = mutableRange;
            }
            else {
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
	[super viewDidUnload];
}

- (void)dealloc {
    [dateFrom release];
    [dateTo release];
    [chartByMonth release];
    [chartByDay release];
    [chartByWeek release];
    [minDates release];
    [maxDates release];
    [categories release];
    [charts release];
    [values release];
	[labelHint release];
	[viewBox release];
    [buttonDateRange release];
    [scrollView release];
    [super dealloc];
}

@end