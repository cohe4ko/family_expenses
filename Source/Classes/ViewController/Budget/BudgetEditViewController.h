//
//  BudgetEditViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Budget.h"

#import "AMButtonItem.h"

@interface BudgetEditViewController : ViewController {

	IBOutlet UIView *viewOverlay;
	
	IBOutlet UIButton *buttonDone;
	IBOutlet UIButton *buttonRepeatLeft;
	IBOutlet UIButton *buttonRepeatRight;
	
	IBOutlet AMButtonItem *buttonAmount;
	IBOutlet AMButtonItem *buttonDateFrom;
	IBOutlet AMButtonItem *buttonDateTo;
	
	IBOutlet UILabel *labelHint;
	
	Budget *budget;
}

@property (nonatomic, retain) Budget *budget;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionAmount:(id)sender;
- (IBAction)actionDateFrom:(id)sender;
- (IBAction)actionDateTo:(id)sender;
- (IBAction)actionRepeat:(UIButton *)sender;


@end
