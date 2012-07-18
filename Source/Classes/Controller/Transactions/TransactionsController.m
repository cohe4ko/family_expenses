//
//  TransactionsController.m
//  Expenses
//

#import "TransactionsController.h"
#import "CategoriesController.h"

#import "NSDate+Utils.h"
#import "DataManager.h"

@implementation TransactionsController

+ (NSMutableArray *)loadTransactions:(SortType)sort {
	
	NSString *sortField = @"";
	if (sort == SortSumm)
		sortField = @"amount";
	else if (sort == SortDate)
		sortField = @"time";
	else if (sort == SortCategores)
		sortField = @"categoriesParentId, categoriesId";
	
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Transactions WHERE state = %d ORDER BY %@", TransactionsStateNormal, sortField];
	return [[[Db shared] loadAndFill:sql theClass:[Transactions class]] mutableCopy];
}

+ (NSMutableArray *)loadTransactions:(SortType)sort minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate{
    NSString *sortField = @"";
	if (sort == SortSumm)
		sortField = @"amount";
	else if (sort == SortDate)
		sortField = @"time";
	else if (sort == SortCategores)
		sortField = @"categoriesParentId, categoriesId";
	
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Transactions WHERE state = %d and time >= %d and time <= %d ORDER BY %@", TransactionsStateNormal,(int)[minDate timeIntervalSince1970], (int)[maxDate timeIntervalSince1970], sortField];
	return [[[Db shared] loadAndFill:sql theClass:[Transactions class]] mutableCopy];
}

+ (NSMutableArray *)loadTransactions:(SortType)sort groupBy:(GroupType)group{
	
	NSString *sortField = @"";
	if (sort == SortSumm)
		sortField = @"amount";
	else if (sort == SortDate)
		sortField = @"time";
    
    NSString *groupField = @"";
    if (group == GroupDay) {
        groupField = @"t.time";
    }else if(group == GroupWeek){
        groupField = @"strftime('%Y%W', t.time, 'unixepoch')";
    }else if(group == GroupMonth){
        groupField = @"strftime('%Y%m', t.time, 'unixepoch')";
    }
	
    if (sort == SortCategores) {
        NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesId categoriesId, %@ groupStr FROM Transactions t WHERE state = %d GROUP BY groupStr", groupField, TransactionsStateNormal];
        return [[[Db shared] loadAndFill:sql theClass:[Transactions class]] mutableCopy];
    }else {
        NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesId categoriesId, %@ groupStr FROM Transactions t WHERE state = %d GROUP BY groupStr ORDER BY %@", groupField, TransactionsStateNormal, sortField];
        return [[[Db shared] loadAndFill:sql theClass:[TransactionsGrouped class]] mutableCopy];
    }
    

}

+ (NSMutableArray *)loadTransactions:(SortType)sort groupBy:(GroupType)group minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate{
    NSString *sortField = @"";
	if (sort == SortSumm)
		sortField = @"amount";
	else if (sort == SortDate)
		sortField = @"time";
    
    NSString *groupField = @"";
    if (group == GroupDay) {
        groupField = @"t.time";
    }else if(group == GroupWeek){
        groupField = @"strftime('%Y%W', t.time, 'unixepoch')";
    }else if(group == GroupMonth){
        groupField = @"strftime('%Y%m', t.time, 'unixepoch')";
    }
	
    if (sort == SortCategores) {
        NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesId categoriesId, %@ groupStr FROM Transactions t WHERE state = %d and time >= %d and time <= %d GROUP BY groupStr", groupField, TransactionsStateNormal,(int)[minDate timeIntervalSince1970],(int)[maxDate timeIntervalSince1970]];
        return [[[Db shared] loadAndFill:sql theClass:[Transactions class]] mutableCopy];
    }else {
        NSString *sql = [NSString stringWithFormat:@"SELECT sum(t.amount) amount, max(t.time) time, t.categoriesId categoriesId, %@ groupStr FROM Transactions t WHERE state = %d and time >= %d and time <= %d GROUP BY groupStr ORDER BY %@", groupField, TransactionsStateNormal, (int)[minDate timeIntervalSince1970],(int)[maxDate timeIntervalSince1970], sortField];
        return [[[Db shared] loadAndFill:sql theClass:[TransactionsGrouped class]] mutableCopy];
    }
}

+ (NSMutableDictionary *)transactionsChartBy:(TransactionsType)type fromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo parentCid:(NSUInteger)pCid {
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	
	// Set date format
	NSString *dateFormat = (type == TransactionsDay) ? @"dd-MM-yyyy" : (type == TransactionsWeek) ? @"w" : @"MM";
	
	// Get transactions from database
	NSString *sql = nil;
    
    if(!pCid)
        sql = [NSString stringWithFormat:@"SELECT * FROM Transactions WHERE state = %d AND (time >= %d AND time <= %d) ORDER BY time", TransactionsStateNormal, (int)[dateFrom timeIntervalSince1970], (int)[dateTo timeIntervalSince1970]];
    else 
        sql = [NSString stringWithFormat:@"SELECT * FROM Transactions WHERE state = %d AND (time >= %d AND time <= %d) AND categoriesParentId = %d ORDER BY time", TransactionsStateNormal, (int)[dateFrom timeIntervalSince1970], (int)[dateTo timeIntervalSince1970], pCid];
        
    
	NSArray *transactions = [[Db shared] loadAndFill:sql theClass:[Transactions class]];
	
	// Generate list
	for (Transactions *m in transactions) {
		
		NSNumber *cid = (pCid)?[NSNumber numberWithInt:m.categoriesId]:[NSNumber numberWithInt:(!m.categoriesParentId)?m.categoriesId:m.categoriesParentId];

        NSUInteger parentCid= [[NSNumber numberWithInt:m.categoriesParentId] integerValue];
		NSString *date = [m.date dateFormat:dateFormat];
		
		if (![dic objectForKey:cid]) {
            if(pCid)
            {
                [dic setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:m.categories.name, @"name", [NSNumber numberWithInt:m.categories.Id], @"cid", [[NSMutableDictionary alloc] init], @"values", nil] forKey:cid];                
            }
            else if(parentCid)
            {
                Categories* c = [CategoriesController getById:parentCid];
                [dic setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                c.name, @"name", [NSNumber numberWithInt:parentCid], @"cid", [[NSMutableDictionary alloc] init], @"values", nil] forKey:cid];
            } else {
                
                [dic setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:m.categories.name, @"name", [NSNumber numberWithInt:m.categories.Id], @"cid", [[NSMutableDictionary alloc] init], @"values", nil] forKey:cid];
            }
		}
		if (![[[dic objectForKey:cid] objectForKey:@"values"] objectForKey:date])
			[[[dic objectForKey:cid] objectForKey:@"values"] setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:m.date, @"date", [NSNumber numberWithInteger:0], @"total", nil] forKey:date];
		
		NSInteger amountTotal = [[[dic objectForKey:cid] objectForKey:@"total"] integerValue] + m.amount;
		[[dic objectForKey:cid] setObject:[NSNumber numberWithInteger:amountTotal] forKey:@"total"];
		
	}
	
	return dic;
}

+ (NSDate*)minumDate{
    NSString *sql = [NSString stringWithFormat:@"SELECT min(time) FROM Transactions"];
    NSInteger timestamp = [[Db shared] intValue:sql];
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}
+ (NSDate*)maximumDate{
    NSString *sql = [NSString stringWithFormat:@"SELECT max(time) FROM Transactions"];
    NSInteger timestamp = [[Db shared] intValue:sql];
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+ (void)createTmpTransactions {
	
	// Clear transactions
	[[Db shared] execute:@"DELETE FROM Transactions"];
	
	// Get categories parent count
	NSInteger cpCount = [[[DataManager shared].categories objectForKey:@"original"] count];
	
	// Get interval
	NSInteger interval = [[NSDate dateStringToDate:[[NSDate date] dateFormat:@"yyyy"] dateFormat:@"yyyy"] timeIntervalSince1970] - [[NSDate dateStringToDate:@"1" dateFormat:@"D"] timeIntervalSince1970];
	
	for (int i = 1; i <= 180; i++) {
		for (int t = 1; t <= (arc4random() % 3) + 1; t++) {
			
			// Get date
			NSDate *date = [[NSDate dateStringToDate:[NSString stringWithFormat:@"%d", i] dateFormat:@"D"] dateByAddingTimeInterval:interval];
			
			// Get categories parent
			Categories *catParent = [[[DataManager shared].categories objectForKey:@"original"] objectAtIndex:(arc4random() % cpCount)];
			
			// Get childs
			NSMutableArray *cTmp = [NSMutableArray arrayWithObject:catParent];
			for (Categories *c in catParent.childs)
				[cTmp addObject:c];
				
			// Get categories
			Categories *cat = [cTmp objectAtIndex:(arc4random() % cTmp.count)];
			
			// Get amount
			NSInteger amount = (arc4random() % 30000);
			
			// Add transaction
			Transactions *t = [Transactions create];
			t.categoriesParentId = catParent.Id;
			t.categoriesId = cat.Id;
			t.time = [date timeIntervalSince1970];
			t.amount = (CGFloat)amount;
			[t save];
		}
		
	}
	
}

@end
