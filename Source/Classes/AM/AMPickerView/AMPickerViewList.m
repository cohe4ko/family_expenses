//
//  AMPickerViewList.m
//  Expenses
//
//  Created by Vinogradov Sergey on 16.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMPickerViewList.h"

@implementation AMPickerViewList

@synthesize picker, list, value, selector, object;

#pragma mark -
#pragma mark Initializate

- (id)initWithTitle:(NSString *)title delegate:(id < UIActionSheetDelegate >)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		parent = [delegate retain];
		
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.00f, 0.00f, 320.00f, 45.00f)];
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
		
		UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
		pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		pickerView.showsSelectionIndicator = YES;
		pickerView.delegate = self;
		pickerView.dataSource = self;
		[self addSubview:pickerView];
		self.picker = pickerView;
		[pickerView release];
		
		list = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)setValue:(NSString *)theValue {
	[theValue retain];
	[value release];
	value = nil;
	value = theValue;
	
	NSDictionary *item = [NSDictionary dictionary];
	int i = 0;
	for (item in list) {
		if ([[item objectForKey:@"value"] isEqualToString:value])
			break;
		i++;
	}
	[self.picker selectRow:i inComponent:0 animated:NO];
}

- (void)setList:(NSMutableArray *)theList {
	[theList retain];
	[list release];
	list = nil;
	list = theList;
	[picker reloadAllComponents];
}

#pragma mark -
#pragma mark Action

- (void)actionCancel {
	[super dismissWithClickedButtonIndex:0 animated:TRUE];
}

- (void)actionDone {
	
	NSDictionary *item = [NSDictionary dictionary];
	for (item in list) {
		if ([[item objectForKey:@"value"] isEqualToString:value])
			break;
	}
	
	if (selector && [parent respondsToSelector:selector]) {
		[parent performSelector:selector withObject:self];
	}
	
	[self dismissWithClickedButtonIndex:1 animated:TRUE];
}

#pragma mark -
#pragma mark UIPickerView dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [list count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[list objectAtIndex:row] objectForKey:@"name"];
}

#pragma mark -
#pragma mark UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	value = [[list objectAtIndex:row] objectForKey:@"value"];
}

#pragma mark -
#pragma mark Draw

- (CGFloat) maxLabelYCoordinate {
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
			if ([view isKindOfClass:[UIPickerView class]]) {
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
	[parent release];
	[object release];
	[value release];
	[super dealloc];
}

@end
