//
//  ReportDiagramViewController.m
//  Expenses
//

#import "ReportDiagramViewController.h"

#import "ReportBox.h"
#import "Transactions.h"
#import "UIColor-Expanded.h"
#import "Transactions.h"
#import "TransactionsController.h"
#import "CategoriesController.h"
#import "ReportDateFilterViewController.h"
#import "SettingsController.h"

@interface ReportDiagramViewController (Private)
- (void) builfGraphForParentCategoryId;
- (void) builfGraphForAllCategories;
- (void) makeLocales;
- (void) makeItems;
- (BOOL) setData;
- (void) animateSettingData;
- (NSInteger)plotType:(CPTPlot*)plot;
- (void)setLocalizedAmountForGraph:(NSInteger)graph amount:(CGFloat)amount;
@end

@implementation ReportDiagramViewController
@synthesize chartByDay;
@synthesize allCatChart;
@synthesize scrollView;
@synthesize labelLowData;
@synthesize reportBoxView = viewBox;
@synthesize buttonDateRange;
@synthesize draggableViewController;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
    selectedGraph = 0;
    
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
    [scrollView addSubview:lensViewSec];
    lensView.center = CGPointMake(scrollView.frame.size.width / 2.0f, scrollView.frame.size.height / 2.0f);
    lensViewSec.center = CGPointMake(3*scrollView.frame.size.width / 2.0f, scrollView.frame.size.height / 2.0f);
    
    scrollView.contentSize = CGSizeMake(2*scrollView.frame.size.width, scrollView.frame.size.height);
    
   
    UIImageView* coverLensView = (UIImageView*)[scrollView viewWithTag:5050];
    coverLensView.exclusiveTouch = NO;
    coverLensView.userInteractionEnabled = NO;
    
}


-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart allCat:(NSDictionary*)allCat
{
    self.chartByDay = chart;
    self.allCatChart = allCat;
    [self setData];
    [self makeLocales];
}

-(void) builfGraphForParentCategoryId
{
    CGFloat offsetX = 0;
    CGFloat wd = 310;
    CGFloat dh = 287;

    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    
    if(hostingView)
    {
        offsetX = hostingView.frame.origin.x;
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
    piePlot.pieRadius  = MIN((hostingView.frame.size.height - 2 * graph.paddingLeft) / 2.0,
                             (hostingView.frame.size.width - 2 * graph.paddingTop) / 2.0);
    CGFloat innerRadius = piePlot.pieRadius / 1.8;
    piePlot.pieInnerRadius  = innerRadius + 5.0;
    piePlot.borderLineStyle = whiteLineStyle;
    piePlot.startAngle      = M_PI_2;
    piePlot.endAngle        = M_PI_2;
    piePlot.sliceDirection  = CPTPieDirectionClockwise;
    //piePlot.shadow          = whiteShadow;
    
    /*CPTGradient *overlayGradient = [[[CPTGradient alloc] init] autorelease];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    piePlot.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    piePlot.rasterizationScale = [UIScreen mainScreen].scale;
    piePlot.shouldRasterize = YES;*/
    
    [graph addPlot:piePlot];
    piePlot.dataSource = self;
    piePlot.delegate        = self;
    [piePlot release];
    
    graph.rasterizationScale = [UIScreen mainScreen].scale;
    graph.shouldRasterize = YES;
    
    [scrollView bringSubviewToFront:lensView];
    lensView.center = hostingView.center;
    roundView.frame = CGRectMake(offsetX+10, 10, roundView.frame.size.width, roundView.frame.size.height);
    
    [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
    
}

- (void)builfGraphForAllCategories{
    CGFloat offsetX = scrollView.frame.size.width;
    CGFloat wd = 310;
    CGFloat dh = 287;
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1011];
    
    if(hostingView)
    {
        offsetX = hostingView.frame.origin.x;
        [hostingView removeFromSuperview];
    }
    
    hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(offsetX,0,wd, dh)];
    hostingView.tag = 1011;
    
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
    piePlot.pieRadius  = MIN((hostingView.frame.size.height - 2 * graph.paddingLeft) / 2.0,
                             (hostingView.frame.size.width - 2 * graph.paddingTop) / 2.0);
    CGFloat innerRadius = piePlot.pieRadius / 1.8;
    piePlot.pieInnerRadius  = innerRadius + 5.0;
    piePlot.borderLineStyle = whiteLineStyle;
    piePlot.startAngle      = M_PI_2;
    piePlot.endAngle        = M_PI_2;
    piePlot.sliceDirection  = CPTPieDirectionClockwise;
    
    /*CPTGradient *overlayGradient = [[[CPTGradient alloc] init] autorelease];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    piePlot.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    piePlot.rasterizationScale = [UIScreen mainScreen].scale;
    piePlot.shouldRasterize = YES;*/
    
    [graph addPlot:piePlot];
    piePlot.dataSource = self;
    piePlot.delegate        = self;
    [piePlot release];
    
    graph.rasterizationScale = [UIScreen mainScreen].scale;
    graph.shouldRasterize = YES;
    
    [scrollView bringSubviewToFront:lensViewSec];
    lensViewSec.center = hostingView.center;
    
    [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
}

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation{
    CPTGraphHostingView *hostingView1 = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
    CPTGraphHostingView *hostingView2 = (CPTGraphHostingView*)[scrollView viewWithTag:1011];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.draggableViewController.draggableHeaderView.hidden = NO;
        self.draggableViewController.draggableCloseHeaderView.hidden = NO;
        self.reportBoxView.hidden = NO;
        buttonDateRange.hidden = NO;
        labelHint.hidden = NO;
        imageViewBg.frame = CGRectMake(0, 6, 320, 352);
        scrollView.frame = CGRectMake(5, 60, 310, 287);
        if (hostingView1) {
            hostingView1.frame = CGRectMake(0, 0, 310, 287);
            lensView.center = hostingView1.center;
        }
        if (hostingView2) {
            hostingView2.frame = CGRectMake(320, 0, 310, 287);
            lensViewSec.center = hostingView2.center;
        }
        roundView.frame = CGRectMake(10, 10, roundView.frame.size.width, roundView.frame.size.height);
        pageControl.frame = CGRectMake(roundf(160-pageControl.frame.size.width/2.0), 327, pageControl.frame.size.width, pageControl.frame.size.height);
    }else {
        self.draggableViewController.draggableHeaderView.hidden = YES;
        self.draggableViewController.draggableCloseHeaderView.hidden = YES;
        self.reportBoxView.hidden = YES;
        buttonDateRange.hidden = YES;
        labelHint.hidden = YES;
        imageViewBg.frame = CGRectMake(0, 0, 480, 300);
        scrollView.frame = CGRectMake(0, 7, 480, 300);
        if (hostingView1) {
            hostingView1.frame = CGRectMake(80, 0, 310, 287);
            lensView.center = hostingView1.center;
        }
        if (hostingView2) {
            hostingView2.frame = CGRectMake(560, 0, 310, 287);
            lensViewSec.center = hostingView2.center;
        }
        roundView.frame = CGRectMake(90, 10, roundView.frame.size.width, roundView.frame.size.height);
        pageControl.frame = CGRectMake(roundf(240-pageControl.frame.size.width/2.0), 300-pageControl.frame.size.height, pageControl.frame.size.width, pageControl.frame.size.height);
    }
    scrollView.contentSize = CGSizeMake(2*scrollView.frame.size.width, scrollView.contentSize.height);
    if (selectedGraph == 0) {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    }else{
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    }
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([self plotType:plot] == 0) {
        if (parentCategoryId > 0) {
            return [[[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"] count];
        }else {
            return [chartByDay count];
        }
    }else{
        return [allCatChart count];
    }

}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    NSNumber* total;
    if ([self plotType:plot] == 0) {
        
        if (parentCategoryId > 0) {
            NSDictionary *subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
            NSNumber* catNum = [subCat.allKeys objectAtIndex:_index];
            total = [[subCat objectForKey:catNum] objectForKey:@"total"];
        }else {
            NSNumber* catNum = [chartByDay.allKeys objectAtIndex:_index];
            total = [[chartByDay objectForKey:catNum] objectForKey:@"total"];
        }
        
    }else{
        NSNumber* catNum = [allCatChart.allKeys objectAtIndex:_index];
        total = [[allCatChart objectForKey:catNum] objectForKey:@"total"];
    }

    return total;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)_index
{
    NSUInteger catId;
    if ([self plotType:pieChart] == 0) {
        
        if (parentCategoryId > 0) {
            NSDictionary *subCat = [[chartByDay objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectForKey:@"subCat"];
            catId = [[subCat.allKeys objectAtIndex:_index] integerValue];
        }else {
            catId = [[chartByDay.allKeys objectAtIndex:_index] integerValue];
        }
        
        
    }else{
        catId = [[allCatChart.allKeys objectAtIndex:_index] integerValue];
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
    [self setLocalizedAmountForGraph:0 amount:selectedTotal];
    
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
    return midPointAngle;
}

-(CGFloat) findMidpointOfSliceAtIndexSec:(NSUInteger)_index
{
    CGFloat midPointAngle = 0;
    // main idea is integrating all amounts before selected slice and find angle
    // from normalization of values
    NSNumber *selectedNum = [allCatChart.allKeys objectAtIndex:_index];
    NSDictionary* data = [allCatChart objectForKey:selectedNum];
   
    // set label, image, etc
    CGFloat selectedTotal =  [[data objectForKey:@"total"] doubleValue];
    
    selectednameLabelSec.text = [data objectForKey:@"name"];
    [self setLocalizedAmountForGraph:1 amount:selectedTotal];
    
    NSUInteger cid = [[data objectForKey:@"cid"] integerValue];
        
    Categories* nativeCat = [CategoriesController getById:cid];
    [lensButtonSec setImage:nativeCat.imageNormal forState:UIControlStateNormal];
    
    CGFloat subTotal = 0;
    for(NSUInteger i = 0; i <= _index; ++i)
    {
        NSNumber* catNum = [allCatChart.allKeys objectAtIndex:i];
        subTotal += [[[allCatChart objectForKey:catNum] objectForKey:@"total"] doubleValue];
    }
    
    
    // then find angle
    midPointAngle = 2.0f * M_PI * (subTotal-selectedTotal * 0.5f) / overAllTotalSec;
    return midPointAngle;
}


-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)_index
{
    if ([self plotType:plot] == 0) {
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
    }else{
        selectedIndexSec = _index;
        currentRotationSec = [self findMidpointOfSliceAtIndexSec:_index];
        
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"startAngle"];
        CABasicAnimation *rotationA = [CABasicAnimation animationWithKeyPath:@"endAngle"];
        rotation.fromValue = [NSNumber numberWithFloat:plot.startAngle];
        rotation.toValue   = [NSNumber numberWithFloat:currentRotationSec + M_PI_2];
        rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationA.fromValue = [NSNumber numberWithFloat:plot.startAngle];
        rotationA.toValue   = [NSNumber numberWithFloat:currentRotationSec + M_PI_2];
        rotationA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotation.duration = 0.3f;
        rotationA.duration = 0.3f;
        plot.startAngle = currentRotationSec + M_PI_2;
        plot.endAngle = currentRotationSec + M_PI_2;
        [plot addAnimation:rotation forKey:@"rotation"];
        [plot addAnimation:rotationA forKey:@"rotationA"];
    }

}

- (NSInteger)plotType:(CPTPlot*)plot{
    if (selectedGraph) {
        CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1010];
        if (hostingView) {
            for (CPTPlot *p in [hostingView.hostedGraph allPlots]) {
                if ([p isEqual:plot]) {
                    return 0;
                }
            }
        }
        
        
        return 1;
    }else{
        CPTGraphHostingView *hostingView = (CPTGraphHostingView*)[scrollView viewWithTag:1011];
        if (hostingView) {
            for (CPTPlot *p in [hostingView.hostedGraph allPlots]) {
                if ([p isEqual:plot]) {
                    return 1;
                }
            }
        }
        
        
        return 0;
    }

}

#pragma mark -
#pragma mark Make

- (void)makeLocales {
	NSDictionary *datesDic = [SettingsController constractIntervalDates];
    NSDate *beginDate = [datesDic objectForKey:@"beginDate"];
    NSDate *endDate = [datesDic objectForKey:@"endDate"];
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ - %@",[beginDate dateFormat:NSLocalizedString(@"report_date_format", @"")],[endDate dateFormat:NSLocalizedString(@"report_date_format", @"")]];
    [buttonDateRange setTitle:buttonTitle forState:UIControlStateNormal];
    
}

- (void)makeItems {
	roundView = [[RIRoundView alloc] initWithFrame:CGRectMake(10, 10, scrollView.frame.size.width-20, scrollView.frame.size.height-20) firstAngle:0.0 secondAngle:2*M_PI innerRadius:(scrollView.frame.size.width-20)/2.5 color:[UIColor whiteColor]];
    [scrollView addSubview:roundView];
    [roundView release];
    roundView.hidden = 0.0;
    
    scrollView.pagingEnabled = YES;
    
    pageControl = [[DDPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    [pageControl setFrame:CGRectMake(roundf(160-pageControl.frame.size.width/2.0), 327, pageControl.frame.size.width, pageControl.frame.size.height)];
    
	[pageControl setType:DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor:[UIColor colorWithHexString:@"6e8bab"]];
	[pageControl setOffColor:[UIColor colorWithHexString:@"cecece"]];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:selectedGraph];
	[pageControl setIndicatorDiameter:6.0f];
	[pageControl setIndicatorSpace:6.0f];
	[self.view addSubview:pageControl];
   
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self updateScrollViewPosition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateScrollViewPosition];
}

- (void)updateScrollViewPosition{
    if (scrollView.contentOffset.x < scrollView.frame.size.width/2.0) {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        pageControl.currentPage = 0;
        
        selectedGraph = 0;
        [viewBox setList:boxCatArray];
    }else{
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        pageControl.currentPage = 1;
        selectedGraph = 1;
        [viewBox setList:boxAllArray];
    }

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
    
    if (boxCatArray) {
        [boxCatArray removeAllObjects];
    }else{
        boxCatArray = [[NSMutableArray alloc] init];
    }
    
    if (boxAllArray) {
        [boxAllArray removeAllObjects];
    }else{
        boxAllArray = [[NSMutableArray alloc] init];
    }
    
    overAllTotal = 0;
    for(NSNumber* cid in chartData.allKeys)
    {
        NSDictionary* d = [chartData objectForKey:cid];
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[d objectForKey:@"name"], @"name", [d objectForKey:@"total"], @"amount", [Categories colorStringForCategiryId:[cid integerValue]], @"color", nil];        
        [boxCatArray addObject:[ReportBox withDictionary:d1]];
        overAllTotal += [[d objectForKey:@"total"] floatValue];
    }
    
    overAllTotalSec = 0;
    for(NSNumber* cid in allCatChart.allKeys)
    {
        NSDictionary* d = [allCatChart objectForKey:cid];
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[d objectForKey:@"name"], @"name", [d objectForKey:@"total"], @"amount", [Categories colorStringForCategiryId:[cid integerValue]], @"color", nil];
        [boxAllArray addObject:[ReportBox withDictionary:d1]];
        overAllTotalSec += [[d objectForKey:@"total"] floatValue];
    }
    
    if (selectedGraph == 0) {
        [viewBox setList:boxCatArray];
    }else{
        [viewBox setList:boxAllArray];
    }
    
    [self builfGraphForParentCategoryId];
    [self builfGraphForAllCategories];
    
    return YES;
}

- (void)setLocalizedAmountForGraph:(NSInteger)graph amount:(CGFloat)amount{
    NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
    
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
    
    
    if (graph == 0) {
        selectedAmountLabel.text = [NSString formatCurrency:amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
    }else{
        selectedAmountLabelSec.text = [NSString formatCurrency:amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
    }
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
    selectedGraph = 0;
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
    [selectednameLabelSec release];
    selectednameLabelSec = nil;
    [selectedAmountLabelSec release];
    selectedAmountLabelSec = nil;
    [lensButtonSec release];
    lensButtonSec = nil;
    [lensViewSec release];
    lensViewSec = nil;
    [imageViewBg release];
    imageViewBg = nil;
    [labelLowData release];
    labelLowData = nil;
    [pageControl release];
    pageControl = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    self.chartByDay = nil;
    self.allCatChart = nil;
    [labelHint release];
    [viewBox release];
    [buttonDateRange release];
    [scrollView release];
    [lensView release];
    [lensViewSec release];
    [selectednameLabel release];
    [selectedAmountLabel release];
    [lensButton release];
    [selectednameLabelSec release];
    [selectedAmountLabelSec release];
    [lensButtonSec release];
    [imageViewBg release];
    [labelLowData release];
    [pageControl release];
    pageControl = nil;
    if (boxAllArray) {
        [boxAllArray release];
        boxAllArray = nil;
    }
    if (boxCatArray) {
        [boxCatArray release];
        boxCatArray = nil;
    }
    [super dealloc];
}

@end