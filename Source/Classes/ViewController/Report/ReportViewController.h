//
//  ReportViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ReportDiagramViewController.h"
#import "ReportChartViewController.h"

@interface ReportViewController : ViewController {
	ReportDiagramViewController *diagramViewController;
	ReportChartViewController *chartViewController;
	
	UIButton *buttonSegmentLeft;
	UIButton *buttonSegmentRight;
	
	SegmentedState segmentedState;
}

@property (nonatomic, retain) ReportDiagramViewController *diagramViewController;
@property (nonatomic, retain) ReportChartViewController *chartViewController;

@end
