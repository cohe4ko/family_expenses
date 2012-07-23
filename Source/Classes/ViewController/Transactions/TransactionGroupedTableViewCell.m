//
//  TransactionGroupedTableViewCell.m
//  Expenses
//
//  Created by MacBook iAPPLE on 06.07.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TransactionGroupedTableViewCell.h"
#import "NSDate+Utils.h"
#import "NSLocale+Currency.h"

@implementation TransactionGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    labelDate.adjustsFontSizeToFitWidth = YES;
    labelPrice.adjustsFontSizeToFitWidth = YES;
}

-(void)setTransaction:(TransactionsGrouped*)_item date:(NSString*)date{
    if (item != _item) {
        if (item) {
            [item release];
            item = nil;
        }
        labelDate.text = date;
        if (!_item) {
            labelPrice.text = nil;
            categoryImageView.image = nil;
            return;
        }
        item = [_item retain];
        [categoryImageView setImage:[item categories].imageNormal];
    }
    // Set price
    NSString *countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings_country_code"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"]-1;
    [labelPrice setText:[item priceForCurrency:[NSLocale currencyCodeForCountryCode:countryCode] points:points]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    if (item) {
        [item release];
    }
    [labelDate release];
    [labelPrice release];
    [categoryImageView release];
    [viewContent release];
    [super dealloc];
}


@end
