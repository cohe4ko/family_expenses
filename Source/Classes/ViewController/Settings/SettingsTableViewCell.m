//
//  SettingsTableViewCell.m
//  Expenses
//
//  Created by Sergey Vinogradov on 09.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell
@synthesize detailLabel;

#pragma mark -
#pragma mark Initializate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:202.0/255.0 blue:183.0/255.0 alpha:1.0];
    
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    self.detailLabel.textColor = [UIColor blackColor];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, self.textLabel.frame.origin.y, 200, self.textLabel.frame.size.height);
    self.detailLabel.frame = CGRectMake(170, self.textLabel.frame.origin.y, 100, self.textLabel.frame.size.height);
}


#pragma mark -
#pragma mark Other

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    [detailLabel release];
    [super dealloc];
}

@end