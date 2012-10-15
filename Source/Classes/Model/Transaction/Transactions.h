//
//  Transactions.h
//  Expenses
//

#import "Model.h"
#import "Categories.h"

typedef enum {
	TransactionsStateNormal		= 0,
	TransactionsStateDeleted	= 1
} TransactionsState;

typedef enum {
	TransactionsDay		= 0,
	TransactionsWeek	= 1,
	TransactionsMonth	= 2
} TransactionsType;

@interface Transactions : DbObject {
	NSInteger repeatType;
	NSInteger repeatValue;
	NSInteger time;
	NSInteger categoriesId;
	NSInteger categoriesParentId;
	
	TransactionsState state;
	
	CGFloat amount;
	
	NSString *desc;
    NSString *sid;
    NSString *device_id;
    NSInteger timestamp;
}

@property (nonatomic, assign) NSInteger repeatType;
@property (nonatomic, assign) NSInteger repeatValue;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger categoriesId;
@property (nonatomic, assign) NSInteger categoriesParentId;
@property (nonatomic, assign) TransactionsState state;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSString *device_id;
@property (nonatomic, assign) NSInteger timestamp;

+ (Transactions *)create;
+ (Transactions *)withDictionary:(NSDictionary *)dic;
- (Transactions *)initWithDictionary:(NSDictionary *)dic;
- (NSDictionary*)asDict:(BOOL)ignoreNil;

- (void)save;
- (void)remove;

- (NSDate *)date;
- (NSString *)repeatName;
- (NSString *)price;

- (BOOL)isRepeat;

- (Categories *)categories;

@end
