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
    NSArray* categories;
    NSArray *subcategories;
    NSDictionary* subcategoriesGroupedByCategory;
    
    CGFloat overAllTotal;
    CGFloat overAllTotalSec;
    CGFloat currentRotation;
    CGFloat currentRotationSec;
    NSUInteger selectedIndex;
    NSUInteger selectedIndexSec;
    NSUInteger parentCid;
    NSUInteger level;
    NSInteger selectedGraph;
    
    NSMutableArray *boxCatArray;
    NSMutableArray *boxAllArray;
}

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray *subcategories;
@property (nonatomic, retain) NSDictionary* subcategoriesGroupedByCategory;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) DDPageControl *pageControl;
@property (nonatomic, readonly) UILabel *labelLowData;
@property (nonatomic, readonly) ReportBoxView *reportBoxView;
@property (nonatomic, readonly) UIButton *buttonDateRange;
@property (nonatomic, readonly) DraggableViewController *draggableViewController;


- (IBAction)actionDateRange:(id)sender;

- (void) setValuesForCategoryGrouped:(NSArray *)categoryGrouped subcategoryGrouped:(NSArray*)subcategoryGrouped subcatGroupedByCat:(NSDictionary*)subcatGroupedByCat;

- (IBAction)onLevelUp:(id)sender;
- (IBAction)onLens:(id)sender;

- (void)renderToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
