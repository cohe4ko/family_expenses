//
//  BudgetController.m
//  Expenses
//

#import "BudgetController.h"

@implementation BudgetController

+ (NSMutableArray *)loadBudget {
	NSString *sql = @"SELECT b.id, b.timeFrom, b.timeTo, b.amount, b.state, b.repeat, b.device_id, b.timestamp, b.sid, (SELECT SUM(t.amount) FROM Transactions AS t WHERE t.time BETWEEN b.timeFrom AND b.timeTo) AS total FROM Budget AS b ORDER BY b.timeFrom, b.timeTo";
	return [[[Db shared] loadAndFill:sql theClass:[Budget class]] mutableCopy];
}

+ (void)clearBudget{
    [[Db shared] execute:@"DELETE FROM Budget"];
}

@end
