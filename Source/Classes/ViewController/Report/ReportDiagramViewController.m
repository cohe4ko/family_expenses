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
#import "ReportDateFilterViewController.h"

@interface ReportDiagramViewController (Private)
- (void) builfGraphForParentCategoryId;
- (void) makeLocales;
- (void) makeItems;
- (BOOL) setData;
- (void) animateSettingData;
@end

@implementation ReportDiagramViewController
@synthesize chartByDay;
@synthesize scrollView;

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


-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart
{
    self.chartByDay = chart;
    [self setData];
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
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
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
    
    /*CPTMutableShadow *whiteShadow = [CPTMutableShadow shadow];
    whiteShadow.shadowOffset     = CGSizeMake(2.0, -4.0);
    whiteShadow.shadowBlurRadius = 4.0;
    whiteShadow.shadowColor      = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];*/

    
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
    //piePlot.shadow          = whiteShadow;
    piePlot.delegate        = self;
    
    [graph addPlot:piePlot];
    [piePlot release];
    
    graph.rasterizationScale = [UIScreen mainScreen].scale;
    graph.shouldRasterize = YES;
    
    [scrollView bringSubviewToFront:lensView];
    
    [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if (parentCategoryId > 0) {
        return [[[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"] count];
    }else {
        return [chartByDay count];
    }
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    NSNumber* total;
    if (parentCategoryId > 0) {
        NSDictionary *subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
        NSNumber* catNum = [subCat.allKeys objectAtIndex:_index];
        total = [[subCat objectForKey:catNum] objectForKey:@"total"];
    }else {
        NSNumber* catNum = [chartByDay.allKeys objectAtIndex:_index];
        total = [[chartByDay objectForKey:catNum] objectForKey:@"total"];
    }
    
    return total;
    
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)_index
{
    NSUInteger catId;
    if (parentCategoryId > 0) {
        NSDictionary *subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
        catId = [[subCat.allKeys objectAtIndex:_index] integerValue];
    }else {
        catId = [[chartByDay.allKeys objectAtIndex:_index] integerValue];
    }
    
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHexString:[Categories colorStringForCategiryId:catId]].CGColor]];
}


-(CGFloat) findMidpointOfSliceAtIndex:(NSUInteger)_index
{
    if(!(overAllTotal > 0))
        return 0;
    
    CGFloat midPointAngle = 0;
    // main idea is integrating all amounts before selected slice and find angle
    // from normalization of values
    NSDictionary* data = nil;
    if (parentCategoryId > 0) {
        NSDictionary* subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
        NSNumber *selectedNum = [subCat.allKeys objectAtIndex:_index];
        data = [subCat objectForKey:selectedNum];
    }else {
        NSNumber *selectedNum = [chartByDay.allKeys objectAtIndex:_index];
        data = [chartByDay objectForKey:selectedNum];
    }
       

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
        if (parentCategoryId > 0) {
            NSDictionary *subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
            NSNumber* catNum = [subCat.allKeys objectAtIndex:i];
            subTotal += [[[subCat objectForKey:catNum] objectForKey:@"total"] floatValue];
        }else {
            NSNumber* catNum = [chartByDay.allKeys objectAtIndex:i];
            subTotal += [[[chartByDay objectForKey:catNum] objectForKey:@"total"] floatValue];
        }


    }
    
    subTotal -= (selectedTotal * 0.5f); // amount to the middle of selected slice
    
    // then find angle
    midPointAngle = 2.0f * M_PI * subTotal / overAllTotal;
    NSLog(@"overAllTotal = %f, _index = %d, midPointAngle=%f, subtotal = %f", overAllTotal, _index,  midPointAngle, subTotal);
    return midPointAngle;
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)_index
{
    selectedIndex = _index;
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
	roundView = [[RIRoundView alloc] initWithFrame:CGRectMake(10, 10, scrollView.frame.size.width-20, scrollView.frame.size.height-20) firstAngle:0.0 secondAngle:2*M_PI innerRadius:(scrollView.frame.size.width-20)/2.5 color:[UIColor whiteColor]];
    [scrollView addSubview:roundView];
    [roundView release];
    roundView.hidden = 0.0;
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDateRange:(id)sender {
    ReportDateFilterViewController *reportDateRangeViewController = [[ReportDateFilterViewController alloc] initWithNibName:@"TransactionGroupViewController_iPhone" bundle:nil];
    [[RootViewController shared] presentModalViewController:reportDateRangeViewController animated:YES];
    [reportDateRangeViewController release];
}

- (IBAction)onLevelUp:(id)sender {
    if(!level)
        return;

    selectedIndex = [chartByDay.allKeys indexOfObject:[NSNumber numberWithInt:parentCategoryId]];
    parentCategoryId = 0;
    level = 0;
    parentCid = 0;
    //animation block
    
    NSNumber* catNum = [chartByDay.allKeys objectAtIndex:selectedIndex];
    NSNumber* total = [[chartByDay objectForKey:catNum] objectForKey:@"total"];
    UIColor *color = [UIColor colorWithHexString:[Categories colorStringForCategiryId:[catNum integerValue]]];
    
    CGFloat totalAngle = 2*M_PI*[total doubleValue]/overAllTotal;
    [roundView resetValuesForFirstAngle:-totalAngle/2.0-M_PI_2 secondAngle:totalAngle/2.0-M_PI_2 innerRadius:roundView.frame.size.width/3.7 color:color];
    [scrollView bringSubviewToFront:roundView];
    [scrollView bringSubviewToFront:lensView];
    roundView.alpha = 1.0;
    [roundView drawFill:YES completion:^{
        [self setData];
        CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
        hostingView.alpha = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            roundView.alpha = 0.0;
            hostingView.alpha = 1.0;
        }];
    }];
}

- (IBAction)onLens:(id)sender {

    if(!(level - 1)){
        [self onLevelUp:sender];
        
        return;
    }
    
    //animation block
    
    NSNumber* catNum = [chartByDay.allKeys objectAtIndex:selectedIndex];
    parentCategoryId = [catNum intValue];
    NSNumber* total = [[chartByDay objectForKey:catNum] objectForKey:@"total"];
    UIColor *color = [UIColor colorWithHexString:[Categories colorStringForCategiryId:[catNum integerValue]]];
    
    CGFloat totalAngle = 2*M_PI*[total doubleValue]/overAllTotal;
    [roundView resetValuesForFirstAngle:-totalAngle/2.0-M_PI_2 secondAngle:totalAngle/2.0-M_PI_2 innerRadius:roundView.frame.size.width/3.7 color:color];
    [scrollView bringSubviewToFront:roundView];
    [scrollView bringSubviewToFront:lensView];
    roundView.alpha = 1.0;

    [roundView drawFill:YES completion:^{
        if([self setData]){
            ++level;
            CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
            hostingView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                roundView.alpha = 0.0;
                hostingView.alpha = 1.0;
            }];
        }
    }];
}

- (void) fadeHostedView:(CGFloat)delay{
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    hostingView.alpha = 0.0;
    [UIView animateWithDuration:0.25f delay:delay options:UIViewAnimationOptionTransitionNone animations:^{
            hostingView.alpha = 1.0;
        } completion:^(BOOL finished){
        }];
}


#pragma mark -
#pragma mark Set

- (BOOL)setData {
	   
    if(!chartByDay){
        return NO;
    }
    
    NSDictionary* chartData = chartByDay;
    
    if (parentCategoryId>0) {
        chartData = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
    }
    
    
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
    self.chartByDay = nil;
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