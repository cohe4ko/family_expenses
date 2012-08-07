//
//  ReportDiagramViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "ReportBoxView.h"
#import "framework/CorePlot-CocoaTouch.h"
#import "RIRoundView.h"

@class DraggableViewController;

@interface ReportDiagramViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTPieChartDelegate> {
	IBOutlet UIScrollView *scrollView;
	
    RIRoundView *roundView;
    
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    IBOutlet UIView *lensView;
    IBOutlet UILabel *selectednameLabel;
    IBOutlet UILabel *selectedAmountLabel;
    IBOutlet UIButton *lensButton;
    
    
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
@property (nonatomic, retain) UIScrollView *scrollView;

- (IBAction)actionDateRange:(id)sender;

-(void) setValues:(NSArray *)val forDic:(NSDictionary*)chart;

- (IBAction)onLevelUp:(id)sender;
- (IBAction)onLens:(id)sender;
@end
