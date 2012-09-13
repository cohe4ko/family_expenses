//
//  ReportBox.m
//  Expenses
//

#import "ReportBox.h"

#import "NSString+Utils.h"
#import "SettingsController.h"

@implementation ReportBox

#pragma mark -
#pragma mark Initializate

@synthesize amount, name, color;

+ (ReportBox *)withDictionary:(NSDictionary *)dic {
	return [[ReportBox alloc] initWithDictionary:dic];
}

- (ReportBox *)initWithDictionary:(NSDictionary *)dic {
	if (self == [super init]) {
		self.amount	= [[dic objectForKey:@"amount"] floatValue];
		self.name	= [dic objectForKey:@"name"];
		self.color	= [dic objectForKey:@"color"];
	}
	return self;
}

#pragma mark -
#pragma mark Getters

- (NSString *)amountString {
	NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"];
    
       
    NSDictionary *currency = [SettingsController currencyForIndex:currencyIndex];
        
    return [NSString formatCurrency:self.amount currencyCode:[currency objectForKey:kCurrencyKeySymbol] numberOfPoints:points orietation:[[currency objectForKey:kCurrencyKeyOrientation] intValue]];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[name release];
	[color release];
	[super dealloc];
}

@end
