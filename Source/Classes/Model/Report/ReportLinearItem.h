//
//  ReportLinearItems.h
//  Expenses
//
//  Created by Ruslan on 20.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "DbObject.h"

@interface ReportLinearItem : DbObject{
    NSInteger time;
    CGFloat amount;
    NSInteger categoriesId;
    NSString *groupStr;
}

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger categoriesId;
@property (nonatomic, retain) NSString *groupStr;

@end
