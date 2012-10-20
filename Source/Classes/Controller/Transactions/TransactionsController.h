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
+ (NSMutableArray *)loadTransactions:(SortType)sort minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (NSMutableArray *)loadTransactions:(SortType)sort groupBy:(GroupType)group;
+ (NSMutableArray *)loadTransactions:(SortType)sort groupBy:(GroupType)group minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate;
+ (NSMutableDictionary *)transactionsChartBy:(TransactionsType)type fromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo parentCid:(NSUInteger)parentCid;
+ (void)createTmpTransactions;
+ (NSDate*)minumDate;
+ (NSDate*)maximumDate;
+ (void)clearTransactions;

@end
