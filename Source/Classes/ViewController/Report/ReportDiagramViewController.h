//
//  ReportDiagramViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "ReportBoxView.h"
#import "framework/CorePlot-CocoaTouch.h"

@class DraggableViewController;

@interface ReportDiagramViewController : ViewController <UIScrollViewDelegate, CPTPlotDataSource, CPTPieChartDelegate> {
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet ReportBoxView *viewBox;
	
	IBOutlet UILabel *labelHint;
	
	IBOutlet UIButton *buttonDateRange;
    
    IBOutlet DraggableViewController* draggableController;
    IBOutlet UIView *lensView;
    IBOutlet UILabel *selectednameLabel;
    IBOutlet UILabel *selectedAmountLabel;
    IBOutlet UIButton *lensButton;
    
    
@private
    NSArray* values;
    
    NSUInteger parentCategoryId;
    NSMutableDictionary* categories;
    NSDictionary* chartByDay;
    
    CGFloat overAllTotal;
    CGFloat currentRotation;
    NSUInteger selectedIndex;
    NSUInteger parentCid;
    NSUInteger level;
}

@property (nonatomic, retain) NSArray* values;
@property (nonatomic, retain) NSMutableDictionary* categories;
@property (nonatomic, retain) NSDictionary* chartByDay;

- (IBAction)actionDateRange:(id)sender;

- (IBAction)onLevelUp:(id)sender;
- (IBAction)onLens:(id)sender;
@end
