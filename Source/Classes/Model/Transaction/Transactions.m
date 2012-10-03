//
//  Transactions.m
//  Expenses
//

#import "Transactions.h"

#import "CategoriesController.h"

#import "DataManager.h"

#import "NSString+Utils.h"
#import "SettingsController.h"

@implementation Transactions

#pragma mark -
#pragma mark Initializate

@synthesize state, repeatType, repeatValue, time, categoriesId, categoriesParentId, amount, desc,sid,device_id,timestamp;

+ (Transactions *)create {
	Transactions *t = [[[Transactions alloc] init] autorelease];
	t.state = TransactionsStateNormal;
	t.repeatType = -1;
	t.repeatValue = -1;
	t.time = time(0);
	t.categoriesId = 0;
	t.categoriesParentId = 0;
	t.amount = 0.0f;
	t.desc = @"";
	return t;
}

+ (Transactions *)withDictionary:(NSDictionary *)dic {
	return [[[Transactions alloc] initWithDictionary:dic] autorelease];
}

- (Transactions *)initWithDictionary:(NSDictionary *)dic {
	if (self == [super init]) {
        self.state = [[dic objectForKey:@"state"] intValue];
        self.repeatType = [[dic objectForKey:@"repeatType"] intValue];
        self.repeatValue = [[dic objectForKey:@"repeatValue"] intValue];
        self.time = [[dic objectForKey:@"time"] integerValue];
        self.categoriesId = [[dic objectForKey:@"categoriesId"] intValue];
        self.categoriesParentId = [[dic objectForKey:@"categoriesParentId"] intValue];;
        self.amount = [[dic objectForKey:@"amount"] floatValue];
        self.desc = [dic objectForKey:@"desc"];
	}
	return self;
}

- (void)save {
    if ([self isNew]) {
        if (![self sid]) {
            self.sid = [NSString stringWithFormat:@"%@%0.0lf",[SettingsController UIID],[[NSDate date] timeIntervalSince1970]];
        }
        if (![self device_id]) {
            self.device_id = [SettingsController UIID];
        }
    }
	if ([[Db shared] save:self]) {
        [Model addTransactionToSync:self.sid];
    }
    
}

- (void)remove {
	self.state = TransactionsStateDeleted;
	[self save];
}

#pragma mark -
#pragma mark Getters

- (NSDate *)date {
	return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSString *)repeatName {
	NSString *s = @"";
	if (repeatValue < 0 || repeatType < 0)
		s = NSLocalizedString(@"transaction_no_repeat", @"");
	else {
        NSString *ss;
        if (repeatType == 0) {
            ss = [NSString stringWithFormat:@"transaction_week_%d", repeatValue];
       		s = NSLocalizedString(ss, @"");
        }else {
            s = [NSString stringWithFormat:NSLocalizedString(@"transaction_month", @""), repeatValue];
        }
		
    }
	return s;
}

- (NSString *)price {
	NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
    
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
    
    return [NSString formatCurrency:self.amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];

}



- (Categories *)categories {
	return [CategoriesController getById:categoriesId];
}

- (BOOL)isRepeat {
	return (repeatType != -1);
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[super dealloc];
}

@end
