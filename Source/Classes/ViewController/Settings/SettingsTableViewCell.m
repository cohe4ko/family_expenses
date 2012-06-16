//
//  SettingsTableViewCell.m
//  Expenses
//
//  Created by Sergey Vinogradov on 09.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

@synthesize item;

#pragma mark -
#pragma mark Initializate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark Set

- (void)setItem:(NSString *)_item {
	if (item != _item) {
		[item release];
		item = nil;
		item = [_item retain];
		
		// Set name
		NSString *name = [NSString stringWithFormat:@"settings_%@", item];
		[labelName setText:NSLocalizedString(name, @"")];
		
		// Set icon
		NSString *icon = [NSString stringWithFormat:@"icon_%@.png", item];
		[imageIcon setImage:[UIImage imageNamed:icon]];
	}
}

#pragma mark -
#pragma mark Other

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[item release];
    [super dealloc];
}

@end