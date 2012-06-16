//
//  AMTextView.m
//  Expenses
//
//  Created by Vinogradov Sergey on 05.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMTextView.h"

@interface AMTextView (PrivateMethods)
- (void)setup;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end

@implementation AMTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;
@synthesize numberOfLines;
@synthesize _textOld;

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	[self setup];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
	
	// Register notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
	
	// Set default placeholder color
	self.placeholderColor = [UIColor lightGrayColor];
	
	_shouldDrawPlaceholder = NO;
	
	self._textOld = self.text;
}

#pragma mark -
#pragma mark Draw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        [_placeholder drawInRect:CGRectMake(8.0, 8.0, self.frame.size.width - 16.0, self.frame.size.height - 16.0) withFont:self.font];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}

- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
	
    [_placeholder release];
    _placeholder = [string retain];
	
    [self _updateShouldDrawPlaceholder];
}

#pragma mark -
#pragma mark Private Methods

- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
	
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];
    
	if (numberOfLines) {
		
		BOOL max = NO;
		
		NSString *newText = self.text;
		
		CGSize tallerSize = CGSizeMake(self.frame.size.width - 16, self.frame.size.height * 2);
		CGSize newSize = [newText sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
		
		if (newSize.height >= self.frame.size.height)
			max = YES;
		else {
			NSArray *lines = [newText componentsSeparatedByString:@"\n"];
			max = !([lines count] <= numberOfLines);
		}
		
		if (max)
			self.text = self._textOld;
	}
	
	self._textOld = self.text;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (numberOfLines) {
		NSLog(@"numbe - %d", numberOfLines);
	}
	return YES;
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
	
    [_placeholder release];
    [_placeholderColor release];
	[_textOld release];
    [super dealloc];
}

@end
