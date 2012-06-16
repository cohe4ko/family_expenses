//
//  Category.m
//  Expenses
//

#import "Categories.h"
#import "DataManager.h"
#import "UIColor-Expanded.h"

@implementation Categories

@synthesize Id, parentId, position, name, desc, imageNormal, imageBordered, childs, isSelected, isFavorite;

#pragma mark -
#pragma mark Initializate

+ (Categories *)withDictionary:(NSDictionary *)dic {
	return [[[Categories alloc] initWithDictionary:dic] autorelease];
}

- (Categories *)initWithDictionary:(NSDictionary *)dic {
	if (self == [super init]) {
		Id			= [[dic objectForKey:@"id"] intValue];
		parentId	= 0;
		position	= [[dic objectForKey:@"position"] intValue];
		name		= [[dic objectForKey:@"name"] retain];
		desc		= [[dic objectForKey:@"desc"] retain];
		childs		= [[[NSMutableArray alloc] init] retain];
		isFavorite	= [[[[DataManager shared] getDic:@"categories_favorite"] objectForKey:[NSNumber numberWithInt:Id]] boolValue];
		
		// Add childs if exists
		if ([dic objectForKey:@"childs"]) {
			for (NSDictionary *item in [dic objectForKey:@"childs"]) {
				Categories *m = [Categories withDictionary:item];
				m.parentId = Id;
				[childs addObject:m];
			}
			
			// Sort childs
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease];
			[childs sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
		}
	}
	return self;
}

#pragma mark -
#pragma mark Copyng

- (id)copyWithZone:(NSZone *)zone {
    Categories *copy = [[[self class] allocWithZone:zone] init];
    [copy setId:self.Id];
	[copy setParentId:self.parentId];
	[copy setPosition:self.position];
	[copy setName:self.name];
	[copy setDesc:self.desc];
	[copy setChilds:self.childs];
	[copy setIsFavorite:self.isFavorite];
    return copy;
}

- (UIImage *)imageNormal {
	if (!imageNormal) {
		imageNormal = [UIImage imageNamed:[NSString stringWithFormat:@"categories_%d.png", Id]];
	}
	return imageNormal;
}

- (UIImage *)imageBordered {
	if (!imageBordered) {
		imageBordered = [UIImage imageNamed:[NSString stringWithFormat:@"categories_%db.png", Id]];;
	}
	return imageBordered;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ - %d", self.name, self.position];
}

+ (NSString*) colorStringForCategiryId:(NSUInteger)catId
{
    NSArray* colorArray = [NSArray arrayWithObjects:@"6cd0eb", @"ffdf7d", @"fd9bbe", @"619e6e", @"e73d3b", @"d13be7", nil];
    
    NSUInteger index = (catId / 100 + catId % 10) % colorArray.count;
    NSString* st = [colorArray objectAtIndex:index];
    
    return st;
}


#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[name release], name = nil;
	[desc release], desc = nil;
	[imageNormal release], imageNormal = nil;
	[imageBordered release], imageBordered = nil;
	[childs release], childs = nil;
	[super dealloc];
}

@end
