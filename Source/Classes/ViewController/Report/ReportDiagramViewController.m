//
//  ReportDiagramViewController.m
//  Expenses
//

#import "ReportDiagramViewController.h"

#import "ReportBox.h"
#import "DraggableViewController.h"
#import "Transactions.h"
#import "UIColor-Expanded.h"
#import "Transactions.h"
#import "TransactionsController.h"
#import "CategoriesController.h"

@interface ReportDiagramViewController (Private)
- (void) builfGraphForParentCategoryId;
- (void) makeLocales;
- (void) makeItems;
- (BOOL) setData;
@end

@implementation ReportDiagramViewController
@synthesize values, categories, chartByDay;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
    
    [self.view addSubview:draggableController.view];
    CGRect f = draggableController.view.frame;
    f.origin.y = self.view.frame.size.height - draggableController.draggableHeaderView.frame.size.height + 8.0f;
    draggableController.view.frame = f;
    draggableController.autocloseInterval = 5.0f;
    draggableController.useAutoclose = YES;
    
    [scrollView addSubview:lensView];
    lensView.center = CGPointMake(scrollView.frame.size.width / 2.0f, scrollView.frame.size.height / 2.0f);
    
    UIImageView* coverLensView = (UIImageView*)[scrollView viewWithTag:5050];
    coverLensView.exclusiveTouch = NO;
    coverLensView.userInteractionEnabled = NO;
    
}


-(void) setValues:(NSArray *)val
{
    [val retain];
    [values release];
    values = val;
    
    self.categories = [NSMutableDictionary dictionary];
        
}

-(void) builfGraphForParentCategoryId
{
    CGFloat offsetX = 0;
    CGFloat wd = scrollView.frame.size.width;
    CGFloat dh = scrollView.frame.size.height;

    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    
    if(hostingView)
    {
        [hostingView removeFromSuperview];
    }
    
    hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(offsetX,0,wd, dh)];
    hostingView.tag = 1010;

    [scrollView addSubview:hostingView];
    CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:hostingView.bounds] autorelease];
    hostingView.hostedGraph = graph;
    [graph release];
    [hostingView release];
    
    graph.plotAreaFrame.masksToBorder = NO;
    
    // Graph padding
    graph.paddingLeft   = 10;
    graph.paddingTop    = 10;
    graph.paddingRight  = 10;
    graph.paddingBottom = 10;
    
    graph.axisSet = nil;
    
    CPTMutableLineStyle *whiteLineStyle = [CPTMutableLineStyle lineStyle];
    whiteLineStyle.lineColor = [CPTColor whiteColor];
    
    CPTMutableShadow *whiteShadow = [CPTMutableShadow shadow];
    whiteShadow.shadowOffset     = CGSizeMake(2.0, -4.0);
    whiteShadow.shadowBlurRadius = 4.0;
    whiteShadow.shadowColor      = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];
    
    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
    piePlot.pieRadius  = MIN((hostingView.frame.size.height - 2 * graph.paddingLeft) / 2.0,
                             (hostingView.frame.size.width - 2 * graph.paddingTop) / 2.0);
    CGFloat innerRadius = piePlot.pieRadius / 1.8;
    piePlot.pieInnerRadius  = innerRadius + 5.0;
    piePlot.borderLineStyle = whiteLineStyle;
    piePlot.startAngle      = M_PI_2;
    piePlot.endAngle        = M_PI_2;
    piePlot.sliceDirection  = CPTPieDirectionClockwise;
    piePlot.shadow          = whiteShadow;
    piePlot.delegate        = self;
    
    [graph addPlot:piePlot];
    [piePlot release];
    
    [scrollView bringSubviewToFront:lensView];
    
    [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [chartByDay count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    NSNumber* catNum = [chartByDay.allKeys objectAtIndex:_index];
    NSNumber* total = [[chartByDay objectForKey:catNum] objectForKey:@"total"];
    return total;
    
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)_index
{
    NSUInteger catId = [[chartByDay.allKeys objectAtIndex:_index] integerValue];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHexString:[Categories colorStringForCategiryId:catId]].CGColor]];
}


-(CGFloat) findMidpointOfSliceAtIndex:(NSUInteger)_index
{
    if(!(overAllTotal > 0))
        return 0;
    
    CGFloat midPointAngle = 0;
    // main idea is integrating all amounts before selected slice and find angle
    // from normalization of values
    
    NSNumber* selectedCatNum = [chartByDay.allKeys objectAtIndex:_index];
    
    NSDictionary* data = [chartByDay objectForKey:selectedCatNum];

    // set label, image, etc
    CGFloat selectedTotal =  [[data objectForKey:@"total"] floatValue];
    
    selectednameLabel.text = [data objectForKey:@"name"];
    selectedAmountLabel.text = [NSString stringWithFormat:@"%@ руб.",[data objectForKey:@"total"]];
    
    NSUInteger cid = [[data objectForKey:@"cid"] integerValue];
    parentCid = cid;
    
    Categories* nativeCat = [CategoriesController getById:cid];
    [lensButton setImage:nativeCat.imageNormal forState:UIControlStateNormal];
    
    CGFloat subTotal = 0;
    for(NSUInteger i = 0; i <= _index; ++i)
    {
        NSNumber* catNum = [chartByDay.allKeys objectAtIndex:i];
        subTotal += [[[chartByDay objectForKey:catNum] objectForKey:@"total"] floatValue];
    }
    
    subTotal -= (selectedTotal * 0.5f); // amount to the middle of selected slice
    
    // then find angle
    midPointAngle = 2.0f * M_PI * subTotal / overAllTotal;
    NSLog(@"overAllTotal = %f, _index = %d, midPointAngle=%f, subtotal = %f", overAllTotal, _index,  midPointAngle, subTotal);
    return midPointAngle;
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)_index
{
    selectedIndex = index;
    currentRotation = [self findMidpointOfSliceAtIndex:_index];

    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"startAngle"];
    CABasicAnimation *rotationA = [CABasicAnimation animationWithKeyPath:@"endAngle"];
    rotation.fromValue = [NSNumber numberWithFloat:plot.startAngle];
    rotation.toValue   = [NSNumber numberWithFloat:currentRotation + M_PI_2];
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationA.fromValue = [NSNumber numberWithFloat:plot.startAngle];
    rotationA.toValue   = [NSNumber numberWithFloat:currentRotation + M_PI_2];
    rotationA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.duration = 0.3f;
    rotationA.duration = 0.3f;
    plot.startAngle = currentRotation + M_PI_2;
    plot.endAngle = currentRotation + M_PI_2;
    [plot addAnimation:rotation forKey:@"rotation"];    
    [plot addAnimation:rotationA forKey:@"rotationA"];    
}

#pragma mark -
#pragma mark Make

- (void)makeLocales {
	
}

- (void)makeItems {
	
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDateRange:(id)sender {

}

- (IBAction)onLevelUp:(id)sender {
    if(!level)
        return;

    level = 0;
    parentCid = 0;
    [self setData];
}

- (IBAction)onLens:(id)sender {

    if(!(level - 1))
        return;
        
    if([self setData])
        ++level;

    

}


#pragma mark -
#pragma mark Set

- (BOOL)setData {
	
    NSMutableDictionary *d = [TransactionsController transactionsChartBy:TransactionsDay fromDate:[NSDate dateStringToDate:@"01-01-2012" dateFormat:@"dd-MM-yyyy"] toDate:[NSDate dateStringToDate:@"31-12-2012" dateFormat:@"dd-MM-yyyy"] parentCid:parentCid];

    NSLog(@"parentCid = %d", parentCid);
    
    if(![d count])
        return NO;
    
    NSDictionary* chartData = d;
    self.chartByDay = d;
    
	NSMutableArray *arr = [[NSMutableArray alloc] init];
    overAllTotal = 0;
    for(NSNumber* cid in chartData.allKeys)
    {
        NSDictionary* d = [chartData objectForKey:cid];
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[d objectForKey:@"name"], @"name", [d objectForKey:@"total"], @"amount", [Categories colorStringForCategiryId:[cid integerValue]], @"color", nil];        
        [arr addObject:[ReportBox withDictionary:d1]];
        overAllTotal += [[d objectForKey:@"total"] floatValue];
    }
    NSLog(@"overAllTotal = %f", overAllTotal);
	[viewBox setList:arr];
    [arr release];
    
    [self builfGraphForParentCategoryId];
    
    return YES;
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
    [viewBox release];
    viewBox = nil;
    [buttonDateRange release];
    buttonDateRange = nil;
    [scrollView release];
    scrollView = nil;
    [lensView release];
    lensView = nil;
    [selectednameLabel release];
    selectednameLabel = nil;
    [selectedAmountLabel release];
    selectedAmountLabel = nil;
    [lensButton release];
    lensButton = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [chartByDay release];
    [categories release];
    [values release];
    [labelHint release];
    [viewBox release];
    [buttonDateRange release];
    [scrollView release];
    [lensView release];
    [selectednameLabel release];
    [selectedAmountLabel release];
    [lensButton release];
    [super dealloc];
}

@end