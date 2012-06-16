//
//  DataManager.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface DataManager : NSObject {
	NSMutableDictionary *data;
	NSMutableDictionary *settings;
	NSMutableDictionary *categories;
}

@property (readwrite, assign) NSMutableDictionary *data;
@property (readwrite, assign) NSMutableDictionary *settings;
@property (nonatomic, retain) NSMutableDictionary *categories;

+ (DataManager *)shared;

- (NSMutableArray *)get:(NSString *)name reset:(BOOL)r;
- (void)set:(NSMutableArray *)dic forKey:(NSString *)name;

- (void)saveDic:(NSDictionary *)object forKey:(NSString *)key;
- (NSDictionary *)getDic:(NSString *)key;

@end
