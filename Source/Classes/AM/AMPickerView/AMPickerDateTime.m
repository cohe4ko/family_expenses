//
//  AMPickerDateTime.m
//  Expenses
//
//  Created by Vinogradov Sergey on 16.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMPickerDateTime.h"

#import "NSDate+Utils.h"

@implementation AMPickerDateTime

@synthesize picker, date, times, datetime, minimum, selector, object;

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	self = [super initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
	
	if (self) {
		
		parent = delegate;
		
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
		toolbar.barStyle = UIBarStyleBlackOpaque;
		
		NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
		
		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel)];
		[buttons addObject:cancelItem];
		[cancelItem release];
		
		UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];	
		[buttons addObject:flexItem];
		[flexItem release];
		
		UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)];
		[buttons addObject:confirmItem];
		[confirmItem release];
		
		[toolbar setItems:buttons animated:NO];
		[buttons release];
		
		[self addSubview:toolbar];
		[self bringSubviewToFront:toolbar];
		[toolbar release];
		
		UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
		datePicker.hidden = NO;
		//datePicker.date = [NSDate date];
		[self addSubview:datePicker];
		self.picker = datePicker;
		
		[datePicker release];
	}
	
	return self;
}

- (void)setDate:(NSDate *)theDate {
	[theDate retain];
	[date release];
	date = nil;
	date = theDate;
	
	self.picker.datePickerMode = UIDatePickerModeDate;
	self.picker.date = date;
}

- (void)setTimes:(NSDate *)theTimes {
	[theTimes retain];
	[times release];
	times = nil;
	times = theTimes;
	
	self.picker.datePickerMode = UIDatePickerModeTime;
	self.picker.minuteInterval = 5;
	self.picker.date = times;
}

- (void)setDatetime:(NSDate *)theDateTime {
	[theDateTime retain];
	[datetime release];
	datetime = nil;
	datetime = theDateTime;
	
	self.picker.datePickerMode = UIDatePickerModeDateAndTime;
	self.picker.minuteInterval = 5;
	self.picker.minimumDate = [[NSDate dateWithTimeIntervalSince1970:time(0) + 3600] roundDateToCeilingMinutes:5];	
	self.picker.date = datetime;
}

- (void)setMinimum:(NSDate *)theMinimum {
	[theMinimum retain];
	[minimum release];
	minimum = nil;
	minimum = theMinimum;
	self.picker.minimumDate = minimum;	
}

- (void)actionCancel {
	[self dismissWithClickedButtonIndex:0 animated:TRUE];
}

- (void)actionDone {
	
	if (selector && [parent respondsToSelector:selector]) {
		[parent performSelector:selector withObject:self];
	}
	
	[self dismissWithClickedButtonIndex:1 animated:TRUE];
}

- (CGFloat)maxLabelYCoordinate {
	CGFloat maxY = 0;
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:[UILabel class]]) {
			CGRect viewFrame = [view frame];
			CGFloat lowerY = viewFrame.origin.y + viewFrame.size.height;
			if (lowerY > maxY)
				maxY = lowerY;
		}
		if ([view isKindOfClass:[UIToolbar class]]) {
			CGRect viewFrame = [view frame];
			CGFloat lowerY = viewFrame.origin.y + viewFrame.size.height;
			if (lowerY > maxY)
				maxY = lowerY;
		}
	}
	return maxY;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if(!layoutDone) {
		CGRect frame = [self frame];
		CGFloat alertWidth = frame.size.width;
		CGFloat pickerHeight = self.picker.frame.size.height;
		CGFloat labelMaxY = [self maxLabelYCoordinate];
		
		for (UIView *view in self.subviews) {
			if ([view isKindOfClass:[UIDatePicker class]]) {
				CGRect viewFrame = CGRectMake(0, labelMaxY, alertWidth, pickerHeight);
				[view setFrame:viewFrame];
			} 
			else if ([view isKindOfClass:[UIToolbar class]]) {
				
			} 
			else if (![view isKindOfClass:[UILabel class]]) {
				CGRect viewFrame = [view frame];
				viewFrame.origin.y += pickerHeight;
				[view setFrame:viewFrame];
			}
		}
		
		frame.size.height += pickerHeight + labelMaxY - 22;
		frame.origin.y -= pickerHeight + labelMaxY - 22;
		[self setFrame:frame];
		layoutDone = YES;
	}
}

- (void)dealloc {
	[picker release];
	[date release];
	[times release];
	[datetime release];
	[minimum release];
	[object release];
    [super dealloc];
}

@end