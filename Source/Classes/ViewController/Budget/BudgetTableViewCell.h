//
//	BudgetTableViewCell.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "Budget.h"

@class BudgetViewController;

@interface BudgetTableViewCell : UITableViewCell {
	
	IBOutlet UIView *viewContent;
	IBOutlet UIView *viewDelete;
	
	IBOutlet UIImageView *imageProgressBackground;
	IBOutlet UIImageView *imageProgress;
	
	IBOutlet UILabel *labelDate;
	IBOutlet UILabel *labelPrice;
	IBOutlet UILabel *labelProgress;
	
	IBOutlet UIButton *buttonDelete;
	
	Budget *item;
	
	BudgetViewController *parent;
	
	BOOL edit;
}

@property (nonatomic, retain) Budget *item;
@property (nonatomic, retain) BudgetViewController *parent;
@property (nonatomic, assign) BOOL edit;

- (IBAction)actionDelete:(id)sender;

- (void)setEdit:(BOOL)_edit animated:(BOOL)animated;

@end
