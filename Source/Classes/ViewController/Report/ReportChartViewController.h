//
//  ReportChartViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "ReportBoxView.h"
#import "framework/CorePlot-CocoaTouch.h"

@class DraggableViewController;

@interface ReportChartViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTAxisDelegate, CPTPlotSpaceDelegate> {
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    
    @private
    
    NSMutableArray* charts;
    
    NSDictionary* chartByDay;
    NSDictionary* chartByWeek;
    NSDictionary* chartByMonth;
    
    NSUInteger currentChart;
    
    NSDate* dateFrom;
    NSDate* dateTo;
    
}


@property (nonatomic, retain) NSDate* dateFrom;
@property (nonatomic, retain) NSDate* dateTo;
@property (nonatomic, retain) NSMutableDictionary* categories;
@property (nonatomic, retain) NSMutableDictionary* minDates;
@property (nonatomic, retain) NSMutableDictionary* maxDates;

//
@property (nonatomic, retain) NSDictionary* chartByDay;
@property (nonatomic, retain) NSDictionary* chartByWeek;
@property (nonatomic, retain) NSDictionary* chartByMonth;
@property (nonatomic, retain) UIScrollView *scrollView;


- (IBAction)actionDateRange:(id)sender;
-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart;

@end
