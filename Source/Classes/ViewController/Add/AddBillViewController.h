//
//  AddBillViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

#import "Categories.h"

#import "AMTextView.h"

#import "Transactions.h"

@interface AddBillViewController : ViewController <UIScrollViewDelegate, UITextViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UIView *viewOverlay;
	
	IBOutlet AMTextView *textView;
	
	IBOutlet UILabel *labelHint;
	IBOutlet UILabel *labelName;
	IBOutlet UILabel *labelRecurring;
	IBOutlet UILabel *labelPrice;
	
	IBOutlet UIImageView *imageLen;
	IBOutlet UIImageView *imageComment;
	IBOutlet UIImageView *imageCommentBorder;
	IBOutlet UIImageView *imageViewName;
	
	AMButton *buttonOk;
	IBOutlet UIButton *buttonDone;
	IBOutlet UIButton *buttonDate;
	IBOutlet UIButton *buttonRecurring;
	IBOutlet UIButton *buttonPageLeft;
	IBOutlet UIButton *buttonPageRight;
    IBOutlet UIButton *buttonClearText;
	
	NSMutableArray *list;
	NSMutableArray *listCategories;
	
	NSInteger selectedIndex;
	
	CGFloat iconWidth;
	CGFloat iconHeight;
	CGFloat amount;
	
	Categories *category;
	Transactions *transaction;
	
	int rows;
}

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *listCategories;
@property (nonatomic, retain) Categories *category;
@property (nonatomic, retain) Transactions *transaction;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionDate:(id)sender;
- (IBAction)actionRecurring:(id)sender;

@end
