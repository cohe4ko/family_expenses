//
//  Calculator.h
//  Expenses
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject {
@private 
	NSMutableString *_display;
	double _operand;
	NSString *_operator;
}

- (void)input:(NSString *)character;
- (NSString *)displayValue;

@end
