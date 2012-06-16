//
//  BudgetViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface BudgetViewController : ViewController {

	IBOutlet UITableView *tableView;
	
	IBOutlet UILabel *labelHint;
	
	NSMutableDictionary *cellEditing;
	
	NSMutableArray *list;
	
	BOOL isEdit;
}

@property (nonatomic, retain) NSMutableDictionary *cellEditing;
@property (nonatomic, retain) NSMutableArray *list;

@end
