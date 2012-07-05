//
//  TransactionsViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface TransactionsViewController : ViewController <UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	
	IBOutlet UIImageView *imageNotepadFooter;
	
	IBOutlet UIView *viewSort;
	
	IBOutlet UILabel *labelHint;
	IBOutlet UILabel *labelSortHeader;
	IBOutlet UILabel *labelDateStart;
	IBOutlet UILabel *labelDateEnd;
	IBOutlet UILabel *labelTotal;
	IBOutlet UILabel *labelTotalName;
	
	IBOutlet UIButton *buttonSortSumm;
	IBOutlet UIButton *buttonSortDate;
	IBOutlet UIButton *buttonSortCategories;
	
	NSMutableDictionary *cellEditing;
	
	SortType sortType;
    GroupType groupType;
	
	BOOL isSort;
	
	NSMutableArray *list;
}

@property (nonatomic, retain) NSMutableDictionary *cellEditing;
@property (nonatomic, assign) SortType sortType;
@property (nonatomic, assign) GroupType groupType;
@property (nonatomic, assign) BOOL isSort;

@property (nonatomic, retain) NSMutableArray *list;

- (IBAction)actionSortButton:(UIButton *)sender;

@end
