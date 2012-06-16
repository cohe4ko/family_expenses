//
//  AMPickerViewList.h
//  Expenses
//
//  Created by Vinogradov Sergey on 16.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPickerViewList : UIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *picker;
	
	NSMutableArray *list;
	NSString *value;
	
	id parent;
	id object;
	
	SEL selector;
	
	BOOL layoutDone;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString *value;

@end