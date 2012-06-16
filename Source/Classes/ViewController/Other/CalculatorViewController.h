//
//  AddCalculatorViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Calculator.h"
#import "Categories.h"

typedef enum {
	CalcDigit0		= 0,
    CalcDigit1		= 1,
	CalcDigit2		= 2,
	CalcDigit3		= 3,
    CalcDigit4		= 4,
	CalcDigit5		= 5,
	CalcDigit6		= 6,
    CalcDigit7		= 7,
	CalcDigit8		= 8,
	CalcDigit9		= 9,
    CalcClear		= 10,
	CalcDelete		= 11,
	CalcDecimal		= 12,
    CalcPlus		= 13,
	CalcMinus		= 14,
	CalcDivide		= 15,
	CalcMultiply	= 16,
	CalcEqual		= 17
} CalcButtonType;

@interface CalculatorViewController : ViewController {
	IBOutlet UIImageView *imageCategory;
	IBOutlet UIImageView *imageLens;
	IBOutlet UIImageView *imageDisplay;
	
	IBOutlet UITextField *textFieldDisplay;
	
	IBOutlet UILabel *labelHint;
	
	IBOutlet UIButton *buttonDigit0;
	IBOutlet UIButton *buttonDigit1;
	IBOutlet UIButton *buttonDigit2;
	IBOutlet UIButton *buttonDigit3;
	IBOutlet UIButton *buttonDigit4;
	IBOutlet UIButton *buttonDigit5;
	IBOutlet UIButton *buttonDigit6;
	IBOutlet UIButton *buttonDigit7;
	IBOutlet UIButton *buttonDigit8;
	IBOutlet UIButton *buttonDigit9;
	IBOutlet UIButton *buttonClear;
	IBOutlet UIButton *buttonDelete;
	IBOutlet UIButton *buttonDecimal;
	IBOutlet UIButton *buttonPlus;
	IBOutlet UIButton *buttonMinus;
	IBOutlet UIButton *buttonDivide;
	IBOutlet UIButton *buttonMultiply;
	IBOutlet UIButton *buttonEqual;
	IBOutlet UIButton *buttonNext;
	
	Categories *category;
	
	Calculator *calculator;
	
	SEL selectorBack;
	id parent;
}

@property (nonatomic, retain) Categories *category;
@property (nonatomic, retain) id parent;
@property (nonatomic, assign) SEL selectorBack;

- (IBAction)actionOperation:(UIButton *)sender;
- (IBAction)actionNext:(id)sender;

@end
