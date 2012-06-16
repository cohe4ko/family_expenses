//
//  AddEditViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AddEditViewController : ViewController {
	IBOutlet UITableView *tableView;
	
	IBOutlet UILabel *labelHint;
	
	IBOutlet UIButton *buttonDone;
	
	NSMutableArray *list;
	
	id parent;
}

@property (nonatomic, retain) id parent;

- (IBAction)actionDone:(id)sender;

@end
