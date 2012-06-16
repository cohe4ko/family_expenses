//
//  Category.h
//  Expenses
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject <NSCopying> {
	int Id;
	int parentId;
	int position;
	
	NSString *name;
	NSString *desc;
	
	UIImage *imageNormal;
	UIImage *imageBordered;
	
	NSMutableArray *childs;
	
	BOOL isSelected;
	BOOL isFavorite;
}

@property (nonatomic, assign) int Id;
@property (nonatomic, assign) int position;
@property (nonatomic, assign) int parentId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) UIImage *imageNormal;
@property (nonatomic, retain) UIImage *imageBordered;
@property (nonatomic, retain) NSMutableArray *childs;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isFavorite;

+ (Categories *)withDictionary:(NSDictionary *)dic;
- (Categories *)initWithDictionary:(NSDictionary *)dic;
+ (NSString*) colorStringForCategiryId:(NSUInteger)catId;

@end
