//
//  TransactionsController.h
//  Expenses
//

#import "MainController.h"
#import "Transactions.h"

@interface TransactionsController : MainController {
	
}

+ (NSMutableArray *)loadTransactions:(SortType)sort;
+ (NSMutableDictionary *)transactionsChartBy:(TransactionsType)type fromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo parentCid:(NSUInteger)parentCid;
+ (void)createTmpTransactions;

@end
