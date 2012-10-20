//
//  ReportViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ReportDiagramViewController.h"
#import "ReportChartViewController.h"

@interface ReportViewController : ViewController<UIGestureRecognizerDelegate> {
	ReportDiagramViewController *diagramViewController;
	ReportChartViewController *chartViewController;
	
    IBOutlet UIView *viewGroup;
    IBOutlet UIButton *buttonGroupDay;
    IBOutlet UIButton *buttonGroupWeek;
    IBOutlet UIButton *buttonGroupMonth;
    IBOutlet UILabel *labelGroupHeader;
    
	UIButton *buttonSegmentLeft;
	UIButton *buttonSegmentRight;
	
	SegmentedState segmentedState;
    
    GroupType groupType;
    BOOL isGroup;
    
    IBOutlet UIActivityIndicatorView *loadingView;
}

@property (nonatomic, retain) ReportDiagramViewController *diagramViewController;
@property (nonatomic, retain) ReportChartViewController *chartViewController;
@property (nonatomic, assign) GroupType groupType;
@property (nonatomic, assign) BOOL isGroup;

@end
