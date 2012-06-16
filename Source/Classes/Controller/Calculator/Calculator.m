//
//  Calculator.m
//  Expenses
//

#import "Calculator.h"

const NSString *operators = @"+-x/";
const NSString *Equals = @"=";
const NSString *Digits = @"0123456789.";
const NSString *Delete = @"D";
const NSString *Clear = @"C";

@implementation Calculator

#pragma -
#pragma mark Initializate

- (id)init {
	if(self = [super init]) {
		_display = [[NSMutableString stringWithCapacity:20] retain];
		_operator = nil;
	}
	return self;
}

#pragma mark -
#pragma mark Setters / Getters

- (NSString *)operator {
	return _operator;
}

- (void)setOperator:(NSString *)operator {
	if(_operator != operator) {
		[_operator release];
		_operator = [operator retain];
	}
}

-(void)input:(NSString *)character {
	static BOOL lastCharacterIsOperator = NO;
	
	// If input character is a digit
	if( [Digits rangeOfString:character].length) {
		if(lastCharacterIsOperator) {
			
			// Set the display to the current character digit
			[_display setString:character];
			lastCharacterIsOperator = NO;
		}
		
		// if input character is not a decimal point (all digits) and last input was an operator
		else if(![character isEqualToString:@"."] || [_display rangeOfString:@"."].location == NSNotFound) {
			
			if ([_display isEqualToString:@"0"])
				[_display setString:character];
			else
				[_display appendString:character];
		}
	}
	
	// If input character is an operator or equals
	else if([operators rangeOfString:character].length || [character isEqualToString:(NSString*)Equals]) {
		
		// If operator is null, and input is not equals
		if(!_operator && ![character isEqualToString:(NSString *)Equals]) {
			_operand = [[self displayValue] doubleValue];
			[self setOperator:character];
		}
		else {
			if(_operator) {
				double operand2 = [[self displayValue] doubleValue];
				switch ([operators rangeOfString: _operator].location) {
					case 0:
						_operand += operand2;
						break;
					case 1:
						_operand -= operand2;
						break;
					case 2:
						_operand *= operand2;
						break;
					case 3:
						_operand /= operand2;
						break;
					default:
						break;
				}
				[_display setString:[[NSNumber numberWithDouble:_operand] stringValue] ];
			}
			[self setOperator:([character isEqualToString:(NSString*)Equals])? nil:character];
		}
		lastCharacterIsOperator = YES;
	}
	else if([character isEqualToString:(NSString *)Delete]) {
		NSInteger indexOfCharToRemove = [_display length] - 1;
		if(indexOfCharToRemove >= 0) {
			[_display deleteCharactersInRange:NSMakeRange(indexOfCharToRemove, 1)];
			lastCharacterIsOperator = NO;
		}
	}
	else if([character isEqualToString:(NSString *)Clear]) {
		if([_display length]) {
			
			// Return an empty string
			[_display setString:[NSString string]];
		}
		else {
			[self setOperator:nil];
		}
	}
}

- (NSString *)displayValue {
	if([_display length]) {
		
		if ([_display isEqualToString:@"inf"] || [_display isEqualToString:@"nan"])
			[_display setString:@"0"];
		
		return [[_display copy] autorelease];
	}
	return @"0";
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[_display release];
	[_operator release];
	[super dealloc];
}

@end