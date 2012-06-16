//
//  Model.m
//  Expenses
//
//  Created by Sergey Vinogradov on 06.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "Model.h"

@implementation Model

- (void)setupDB {
	NSLog(@"setupDB");
	[[Db shared] execute:@"DROP TABLE IF EXISTS Transaction"];
	[[Db shared] execute:@"CREATE TABLE Transaction (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, repeatType INTEGER, repeatValue INTEGER, time INTEGER, categoriesId INTEGER, categoriesParentId INTEGER, amount REAL, desc TEXT)"];
}

@end
