//
//  ReportBox.m
//  Expenses
//

#import "ReportBox.h"

#import "NSString+Utils.h"

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
	return [NSString stringWithFormat:@"%@ %@", [NSString formatCurrency:self.amount def:@"0"], @"руб"];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[name release];
	[color release];
	[super dealloc];
}

@end
