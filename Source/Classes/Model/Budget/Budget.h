//
//  Budget.h
//  Expenses
//

#import "Model.h"

typedef enum {
	BudgetStateNormal	= 0,
	BudgetStateDeleted	= 1
} BudgetState;

typedef enum {
	BudgetRepeatNone	= 0,
	BudgetRepeatWeek	= 1,
	BudgetRepeatMonth	= 2
} BudgetRepeat;

@interface Budget : DbObject {
	NSInteger timeFrom;
	NSInteger timeTo;
	
	CGFloat amount;
	CGFloat total;
	
	BudgetState state;
	BudgetRepeat repeat;
}

@property (nonatomic, assign) NSInteger timeFrom;
@property (nonatomic, assign) NSInteger timeTo;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) BudgetState state;
@property (nonatomic, assign) BudgetRepeat repeat;

+ (Budget *)create;
+ (Budget *)withDictionary:(NSDictionary *)dic;
- (Budget *)initWithDictionary:(NSDictionary *)dic;

- (NSDate *)dateFrom;
- (NSDate *)dateTo;

- (NSString*)localizedAmount;
- (NSString*)localizedTotal;

- (CGFloat)progressPercent;

- (UIImage *)progressImage;

- (void)save;
- (void)remove;

@end
