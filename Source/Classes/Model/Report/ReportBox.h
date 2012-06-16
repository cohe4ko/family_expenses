//
//  ReportBox.h
//  Expenses
//

#import <Foundation/Foundation.h>


@interface ReportBox : NSObject {
	CGFloat amount;
	
	NSString *name;
	NSString *color;
}

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *color;

+ (ReportBox *)withDictionary:(NSDictionary *)dic;
- (ReportBox *)initWithDictionary:(NSDictionary *)dic;

- (NSString *)amountString;

@end
