//
//  ReportDiagramViewController.m
//  Expenses
//

#import "ReportDiagramViewController.h"

#import "ReportBox.h"
#import "Transactions.h"
#import "UIColor-Expanded.h"
#import "ReportCategoryPieItem.h"
#import "ReportSubcategoryPieItem.h"
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
@synthesize categories;
@synthesize subcategories;
@synthesize subcategoriesGroupedByCategory;
@synthesize scrollView;
@synthesize labelLowData;
@synthesize reportBoxView = viewBox;
@synthesize buttonDateRange;
@synthesize draggableViewController;
@synthesize pageControl;

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


- (void) setValuesForCategoryGrouped:(NSArray *)categoryGrouped subcategoryGrouped:(NSArray*)subcategoryGrouped subcatGroupedByCat:(NSDictionary*)subcatGroupedByCat
{
    self.categories = categoryGrouped;
    self.subcategories = subcategoryGrouped;
    self.subcategoriesGroupedByCategory = subcatGroupedByCat;
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
    
    if ([self.categories count] > 0) {
        [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
    }
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
    
    if ([self.subcategories count] > 0) {
        [self pieChart:piePlot sliceWasSelectedAtRecordIndex:0];
    }
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
            return [[self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]] count];
        }else {
            return [self.categories count];
        }
    }else{
        return [self.subcategories count];
    }

}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)_index
{
    NSNumber* total;
    if ([self plotType:plot] == 0) {
        
        if (parentCategoryId > 0) {
            ReportSubcategoryPieItem *subCatItem = [[self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectAtIndex:_index];
            total = [NSNumber numberWithFloat:subCatItem.amount];
        }else {
            ReportCategoryPieItem *catItem = [self.categories objectAtIndex:_index];
            total = [NSNumber numberWithFloat:catItem.amount];
        }
        
    }else{
        ReportSubcategoryPieItem *subcatItem = [self.subcategories objectAtIndex:_index];
        total = [NSNumber numberWithFloat:subcatItem.amount];
    }

    return total;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)_index
{
    NSUInteger catId;
    if ([self plotType:pieChart] == 0) {
        
        if (parentCategoryId > 0) {
            ReportSubcategoryPieItem *subCatItem = [[self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectAtIndex:_index];
            catId = subCatItem.categoriesId;
        }else {
            ReportCategoryPieItem *catItem = [self.categories objectAtIndex:_index];
            catId = catItem.categoriesId;
        }
        
        
    }else{
        ReportSubcategoryPieItem *subcatItem = [self.subcategories objectAtIndex:_index];
        catId = subcatItem.categoriesId;
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
    CGFloat selectedTotal;
    NSUInteger cid;
    if (parentCategoryId > 0) {
        ReportSubcategoryPieItem *subCatItem = [[self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectAtIndex:_index];
        selectedTotal = subCatItem.amount;
        cid = subCatItem.categoriesId;
    }else {
        ReportCategoryPieItem *catItem = [self.categories objectAtIndex:_index];
        selectedTotal = catItem.amount;
        cid = catItem.categoriesId;
    }
    
    // set label, image, etc
    Categories* nativeCat = [CategoriesController getById:cid];
    selectednameLabel.text = [nativeCat name];
    [self setLocalizedAmountForGraph:0 amount:selectedTotal];
    
    parentCid = cid;
    
    [lensButton setImage:nativeCat.imageNormal forState:UIControlStateNormal];
    
    CGFloat subTotal = 0;
    for(NSUInteger i = 0; i <= _index; ++i)
    {
        if (parentCategoryId > 0) {
            ReportSubcategoryPieItem *subCatPieItem = [[self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]] objectAtIndex:i];
            subTotal += subCatPieItem.amount;
        }else {
            ReportCategoryPieItem *catPieItem = [self.categories objectAtIndex:i];
            subTotal += catPieItem.amount;
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
    ReportSubcategoryPieItem *subCatItem = [self.subcategories objectAtIndex:_index];
   
    // set label, image, etc
    CGFloat selectedTotal =  subCatItem.amount;
    NSUInteger cid = subCatItem.categoriesId;
    
    Categories* nativeCat = [CategoriesController getById:cid];
    
    selectednameLabelSec.text = [nativeCat name];
    [self setLocalizedAmountForGraph:1 amount:selectedTotal];
        
    [lensButtonSec setImage:nativeCat.imageNormal forState:UIControlStateNormal];
    
    CGFloat subTotal = 0;
    for(NSUInteger i = 0; i <= _index; ++i)
    {
        ReportSubcategoryPieItem *subCatItem = [self.subcategories objectAtIndex:i];
        subTotal += subCatItem.amount;
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

    selectedIndex = 0;
    
    for (int i = 0; i < [self.categories count]; i++) {
        ReportCategoryPieItem *catPieItem = [self.categories objectAtIndex:i];
        if (catPieItem.categoriesId = parentCategoryId) {
            selectedIndex = i;
            break;
        }
    }
    
    parentCategoryId = 0;
    level = 0;
    parentCid = 0;
    //animation block
    
    ReportCategoryPieItem *catPieItem = [self.categories objectAtIndex:selectedIndex];
    UIColor *color = [UIColor colorWithHexString:[Categories colorStringForCategiryId:catPieItem.categoriesId]];
    
    CGFloat totalAngle = 2*M_PI*catPieItem.amount/overAllTotal;
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
    
    ReportCategoryPieItem *catPieItem = [self.categories objectAtIndex:selectedIndex];
    parentCategoryId = catPieItem.categoriesId;
    UIColor *color = [UIColor colorWithHexString:[Categories colorStringForCategiryId:catPieItem.categoriesId]];
    
    CGFloat totalAngle = 2*M_PI*catPieItem.amount/overAllTotal;
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
	   
    if(!self.categories || !self.subcategories || !self.subcategoriesGroupedByCategory){
        return NO;
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
    
    if (parentCategoryId>0) {
        for(ReportSubcategoryPieItem *subCatPieItem in [self.subcategoriesGroupedByCategory objectForKey:[NSNumber numberWithInt:parentCategoryId]])
        {
            Categories *category = [CategoriesController getById:subCatPieItem.categoriesId];
            NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[category name], @"name", [NSNumber numberWithFloat:subCatPieItem.amount], @"amount", [Categories colorStringForCategiryId:subCatPieItem.categoriesId], @"color", nil];
            [boxCatArray addObject:[ReportBox withDictionary:d1]];
            overAllTotal += subCatPieItem.amount;
        }
    }else{
        for(ReportCategoryPieItem *catPieItem in self.categories)
        {
            Categories *category = [CategoriesController getById:catPieItem.categoriesId];
            NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[category name], @"name", [NSNumber numberWithFloat:catPieItem.amount], @"amount", [Categories colorStringForCategiryId:catPieItem.categoriesId], @"color", nil];
            [boxCatArray addObject:[ReportBox withDictionary:d1]];
            overAllTotal += catPieItem.amount;
        }
    }
    
    
    
    overAllTotalSec = 0;
    for(ReportSubcategoryPieItem *subcatPieItem in self.subcategories)
    {
        Categories *category = [CategoriesController getById:subcatPieItem.categoriesId];
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[category name], @"name", [NSNumber numberWithFloat:subcatPieItem.amount], @"amount", [Categories colorStringForCategiryId:subcatPieItem.categoriesId], @"color", nil];
        [boxAllArray addObject:[ReportBox withDictionary:d1]];
        overAllTotalSec += subcatPieItem.amount;
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
    self.categories = nil;
    self.subcategories = nil;
    self.subcategoriesGroupedByCategory = nil;
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