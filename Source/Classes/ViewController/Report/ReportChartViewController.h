//
//  ReportChartViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DraggableViewController.h"
#import "ReportBoxView.h"
#import "framework/CorePlot-CocoaTouch.h"

@interface ReportChartViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTAxisDelegate, CPTPlotSpaceDelegate> {
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
    IBOutlet UILabel *labelLowData;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    IBOutlet UIImageView *imageViewBg;
    
    GroupType groupType;
    
    @private
    
    NSDictionary* chart;
    NSArray *boxArray;
    
    CGFloat currentScale;
    
    NSDate* dateFrom;
    NSDate* dateTo;
    
}


@property (nonatomic, retain) NSDate* dateFrom;
@property (nonatomic, retain) NSDate* dateTo;

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UILabel *labelLowData;
@property (nonatomic, readonly) ReportBoxView *reportViewBox;
@property (nonatomic, readonly) UIButton *buttonDateRange;
@property (nonatomic, readonly) DraggableViewController *draggableViewController;
@property (nonatomic, assign) GroupType groupType;


- (IBAction)actionDateRange:(id)sender;
-(void) setValues:(NSDictionary*)values forBoxData:(NSArray*)boxData forMaxAmount:(CGFloat)maxAmount;

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
