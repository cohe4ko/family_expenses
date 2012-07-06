//
//  TransactionsController.h
//  Expenses
//

#import "MainController.h"
#import "Transactions.h"
#import "TransactionsGrouped.h"

@interface TransactionsController : MainController {
	
}

+ (NSMutableArray *)loadTransactions:(SortType)sort;
+ (NSMutableArray *)loadTransactions:(SortType)sort groupBy:(GroupType)group;
+ (NSMutableDictionary *)transactionsChartBy:(TransactionsType)type fromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo parentCid:(NSUInteger)parentCid;
+ (void)createTmpTransactions;

@end
