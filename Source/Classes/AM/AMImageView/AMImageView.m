//
//  AMImageView.m
//  Expenses
//
//  Created by Sergey Vinogradov on 13.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMImageView.h"

@implementation AMImageView

- (void)awakeFromNib {
	self.image = [self.image stretchableImageWithLeftCapWidth:10.00f topCapHeight:10.00f];
}

@end
