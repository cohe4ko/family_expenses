//
//  TransactionsViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface TransactionsViewController : ViewController <UITableViewDelegate, UIGestureRecognizerDelegate> {
	IBOutlet UITableView *tableView;
	
	IBOutlet UIImageView *imageNotepadFooter;
    IBOutlet UIImageView *imageNotepadHeader;
	
	IBOutlet UIView *viewSort;
    IBOutlet UIView *viewGroup;
	
	IBOutlet UILabel *labelHint;
	IBOutlet UILabel *labelSortHeader;
    IBOutlet UILabel *labelGroupHeader;
	IBOutlet UILabel *labelDateStart;
	IBOutlet UILabel *labelDateEnd;
	IBOutlet UILabel *labelTotal;
	IBOutlet UILabel *labelTotalName;
	
	IBOutlet UIButton *buttonSortSumm;
	IBOutlet UIButton *buttonSortDate;
	IBOutlet UIButton *buttonSortCategories;
    IBOutlet UIButton *buttonGroupDay;
    IBOutlet UIButton *buttonGroupWeek;
    IBOutlet UIButton *buttonGroupMonth;
    IBOutlet UIButton *buttonGroupAll;
	IBOutlet UIActivityIndicatorView *loadingView;
    NSMutableDictionary *cellEditing;
	
	SortType sortType;
    GroupType groupType;
	
	BOOL isSort;
    BOOL isGroup;
	
	NSMutableArray *list;
    
    Transactions *addingTransaction;
    NSInteger currentIndex;
}

@property (nonatomic, retain) NSMutableDictionary *cellEditing;
@property (nonatomic, assign) SortType sortType;
@property (nonatomic, assign) GroupType groupType;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, assign) BOOL isGroup;

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) Transactions *addingTransaction;

- (IBAction)actionSortButton:(UIButton *)sender;
- (void)addTransactionAnimated:(Transactions*)t;

@end
