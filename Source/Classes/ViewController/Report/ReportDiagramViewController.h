//
//  ReportDiagramViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DraggableViewController.h"
#import "ReportBoxView.h"
#import "framework/CorePlot-CocoaTouch.h"
#import "RIRoundView.h"
#import "DDPageControl.h"

@interface ReportDiagramViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTPieChartDelegate> {
	IBOutlet UIScrollView *scrollView;
	
    RIRoundView *roundView;
    
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
    IBOutlet UILabel *labelLowData;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    IBOutlet UIView *lensView;
    IBOutlet UIView *lensViewSec;
    IBOutlet UILabel *selectednameLabel;
    IBOutlet UILabel *selectedAmountLabel;
    IBOutlet UILabel *selectednameLabelSec;
    IBOutlet UILabel *selectedAmountLabelSec;
    IBOutlet UIButton *lensButton;
    IBOutlet UIButton *lensButtonSec;
    
    IBOutlet UIImageView *imageViewBg;
    
    DDPageControl *pageControl;
    
@private
   
    NSUInteger parentCategoryId;
    NSDictionary* chartByDay;
    NSDictionary* allCatChart;
    
    CGFloat overAllTotal;
    CGFloat overAllTotalSec;
    CGFloat currentRotation;
    CGFloat currentRotationSec;
    NSUInteger selectedIndex;
    NSUInteger selectedIndexSec;
    NSUInteger parentCid;
    NSUInteger level;
    NSInteger selectedGraph;
}

@property (nonatomic, retain) NSDictionary* chartByDay;
@property (nonatomic, retain) NSDictionary* allCatChart;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UILabel *labelLowData;
@property (nonatomic, readonly) ReportBoxView *reportBoxView;
@property (nonatomic, readonly) UIButton *buttonDateRange;
@property (nonatomic, readonly) DraggableViewController *draggableViewController;


- (IBAction)actionDateRange:(id)sender;

-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart allCat:(NSDictionary*)allCat;

- (IBAction)onLevelUp:(id)sender;
- (IBAction)onLens:(id)sender;

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
