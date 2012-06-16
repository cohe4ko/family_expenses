//
//  BCTab.h
//  Expenses
//
//  Created by Vinogradov Sergey on 10.02.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

@interface BCTab : UIButton {
	NSString *name;
	NSString *imageName;
	UILabel *label;
	UIImageView *background;
	BOOL isCenter;
	int idx;
}

@property (nonatomic, readwrite) BOOL isCenter;
@property (nonatomic, assign) int idx;

- (id)initWithIconImageName:(NSString *)imageName andName:(NSString *)theName;

@end
