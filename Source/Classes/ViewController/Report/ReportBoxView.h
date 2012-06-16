//
//  ReportBoxView.h
//  Expenses
//

#import <UIKit/UIKit.h>

@interface ReportBoxView : UIView <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;

	NSMutableArray *list;
}

@property (nonatomic, retain) NSMutableArray *list;

@end
