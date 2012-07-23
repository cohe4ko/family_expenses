//
//  BudgetController.h
//  Expenses
//

#import "MainController.h"
#import "Budget.h"

@interface BudgetController : MainController {
	
}

+ (NSMutableArray *)loadBudget;
+ (void)clearBudget;

@end
