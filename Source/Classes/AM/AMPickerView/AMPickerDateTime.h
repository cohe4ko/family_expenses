//
//  AMPickerDateTime.h
//  Expenses
//
//  Created by Vinogradov Sergey on 16.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMPickerDateTime : UIActionSheet {
	UIDatePicker *picker;
	
	NSDate *date;
	NSDate *times;
	NSDate *datetime;
	NSDate *minimum;
	
	BOOL layoutDone;
	
	id parent;
	id object;
	
	SEL selector;
}

@property (nonatomic, retain) UIDatePicker *picker;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *times;
@property (nonatomic, retain) NSDate *datetime;
@property (nonatomic, retain) NSDate *minimum;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) SEL selector;

@end
