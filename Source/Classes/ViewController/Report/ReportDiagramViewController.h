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

@interface ReportDiagramViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTPieChartDelegate> {
	IBOutlet UIScrollView *scrollView;
	
    RIRoundView *roundView;
    
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
    IBOutlet UILabel *labelLowData;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    IBOutlet UIView *lensView;
    IBOutlet UILabel *selectednameLabel;
    IBOutlet UILabel *selectedAmountLabel;
    IBOutlet UIButton *lensButton;
    
    IBOutlet UIImageView *imageViewBg;
    
@private
   
    NSUInteger parentCategoryId;
    NSDictionary* chartByDay;
    
    CGFloat overAllTotal;
    CGFloat currentRotation;
    NSUInteger selectedIndex;
    NSUInteger parentCid;
    NSUInteger level;
}

@property (nonatomic, retain) NSDictionary* chartByDay;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UILabel *labelLowData;
@property (nonatomic, readonly) ReportBoxView *reportBoxView;
@property (nonatomic, readonly) UIButton *buttonDateRange;
@property (nonatomic, readonly) DraggableViewController *draggableViewController;


- (IBAction)actionDateRange:(id)sender;

-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart;

- (IBAction)onLevelUp:(id)sender;
- (IBAction)onLens:(id)sender;

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
