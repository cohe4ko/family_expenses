//
//  ReportCategoryPieItem.h
//  Expenses
//
//  Created by Ruslan on 20.10.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "DbObject.h"

@interface ReportCategoryPieItem : DbObject{
    NSInteger time;
    CGFloat amount;
    NSInteger categoriesId;
}

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger categoriesId;

@end
