//
//  CategoryController.m
//  Expenses
//

#import "CategoriesController.h"
#import "DataManager.h"

@implementation CategoriesController

+ (void)loadCategories {
	
	NSArray *tmp = [super loadPlist:@"Categories"];
	
	NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
	for (NSDictionary *item in tmp) {
		[list addObject:[Categories withDictionary:item]];
	}
	
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease];
	[list sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	
	[[DataManager shared].categories setObject:list forKey:@"original"];
}

+ (NSMutableArray *)loadCategoriesFavorite {
	NSMutableArray *list = [[NSMutableArray alloc] init];
	
	NSDictionary *dicPosition = [[DataManager shared] getDic:@"categories_position"];
	
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		if (m.isFavorite) {
            [m setPosition:[[dicPosition objectForKey:[NSNumber numberWithInt:m.Id]] intValue]];
			[list addObject:m];
        }
		for (Categories *mm in m.childs) {
			if (mm.isFavorite) {
                [mm setPosition:[[dicPosition objectForKey:[NSNumber numberWithInt:mm.Id]] intValue]];
				[list addObject:mm];
            }
		}
	}
    
    NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease];
	[list sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	
	return [list autorelease];
}

+ (Categories *)getByParent:(NSInteger)parentId {
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		if (m.Id == parentId) {
			return m;
		}
	}
	return nil;
}

+ (Categories *)getById:(NSInteger)categoriesId {
	Categories *categories = nil;
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		if (m.Id == categoriesId) {
			categories = m;
			break;
		}
		for (Categories *mm in m.childs) {
			if (mm.Id == categoriesId) {
				categories = mm;
				break;
			}
		}
	}
	return categories;
}

@end
