//
//  Budget.m
//  Expenses
//

#import "Budget.h"

#import "NSDate+Utils.h"
#import "SettingsController.h"
#import "NSString+Utils.h"

@implementation Budget

#pragma mark -
#pragma mark Initializate

@synthesize timeFrom, timeTo, amount, state, repeat, total;

+ (Budget *)create {
	Budget *t = [[[Budget alloc] init] autorelease];
	t.repeat = BudgetRepeatMonth;
	t.state = BudgetStateNormal;
	t.amount = 0.0f;
	t.timeFrom = time(0);
	t.timeTo = [[[NSDate date] monthNext] timeIntervalSince1970];
	return t;
}

+ (Budget *)withDictionary:(NSDictionary *)dic {
	return [[Budget alloc] initWithDictionary:dic];
}

- (Budget *)initWithDictionary:(NSDictionary *)dic {
	if (self == [super init]) {
	
	}
	return self;
}

#pragma mark -
#pragma mark Getters

- (NSDate *)dateFrom {
	return [NSDate dateWithTimeIntervalSince1970:self.timeFrom];
}

- (NSDate *)dateTo {
	return [NSDate dateWithTimeIntervalSince1970:self.timeTo];
}

- (CGFloat)progressPercent {
	return self.total / (self.amount / 100.0f);
}

- (UIImage *)progressImage {
	CGFloat p = self.progressPercent;
	NSString *n = @"green";
	if (p >= 66)
		n = @"red";
	else if (p >= 33)
		n = @"orange";
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"budget_progress_%@.png", n]];
	return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
		
}

- (NSString*)localizedAmount{
    NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
    
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
    
    return [NSString formatCurrency:self.amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
}

- (NSString*)localizedTotal{
    NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
    
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
    
    return [NSString formatCurrency:self.total currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
}

#pragma mark -
#pragma mark Operations

- (void)save {
	[[Db shared] save:self];
}

- (void)remove {
	self.state = BudgetStateDeleted;
	[self save];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[super dealloc];
}

@end
