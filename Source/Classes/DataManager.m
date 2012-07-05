//
//  DataManager.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"

static DataManager *sharedDataManager;

@implementation DataManager

@synthesize data;
@synthesize settings;
@synthesize categories;

+ (DataManager *)shared {
	if (!sharedDataManager) {
		sharedDataManager = [[DataManager alloc] init];
	}
	return sharedDataManager;
}

- (id)init {
    if (self = [super init]) {
		self.data	= [[[NSMutableDictionary alloc] init] autorelease]; 
		self.settings = [[[NSMutableDictionary alloc] init] autorelease];
		self.categories = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (NSMutableArray *)get:(NSString *)name reset:(BOOL)r {
	if ([self.data objectForKey:name] == nil || r) {
		NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
		[self.data setObject:arr forKey:name];
	}
	return [self.data objectForKey:name]; 
}

- (void)set:(NSMutableArray *)dic forKey:(NSString *)name {
	if ([self.data objectForKey:name] == nil)
		[self get:name reset:TRUE]; 
	[self.data setObject:dic forKey:name];
}

- (void)saveDic:(NSDictionary *)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getDic:(NSString *)key {
	NSData *_data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (_data && [_data length])
		return [NSKeyedUnarchiver unarchiveObjectWithData:_data];
	return [[[NSMutableDictionary alloc] init] autorelease];
}

- (void)dealloc {
	[sharedDataManager release];
	[data release];
	[settings release];
	[categories release];
	[super dealloc];
}

@end
