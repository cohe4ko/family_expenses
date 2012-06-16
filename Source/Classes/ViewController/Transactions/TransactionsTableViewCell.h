//
//  TransactionsTableViewCell.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "Transactions.h"

@class TransactionsViewController;

@interface TransactionsTableViewCell : UITableViewCell {
	
	IBOutlet UIView *viewContent;
	IBOutlet UIView *viewDelete;
	
	IBOutlet UIImageView *imageViewIcon;
	IBOutlet UIImageView *imageViewRepeat;
	
	IBOutlet UILabel *labelCategories;
	IBOutlet UILabel *labelDesc;
	IBOutlet UILabel *labelDate;
	IBOutlet UILabel *labelPrice;
	
	IBOutlet UIButton *buttonDelete;
	
	Transactions *item;
	
	TransactionsViewController *parent;
	
	BOOL edit;
}

@property (nonatomic, retain) Transactions *item;
@property (nonatomic, retain) TransactionsViewController *parent;
@property (nonatomic, assign) BOOL edit;

- (IBAction)actionDelete:(id)sender;

- (void)setEdit:(BOOL)_edit animated:(BOOL)animated;

@end
