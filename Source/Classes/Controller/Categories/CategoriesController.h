//
//  CategoryController.h
//  Expenses
//

#import "MainController.h"
#import "Categories.h"

@interface CategoriesController : MainController {
	
}

+ (void)loadCategories;
+ (NSMutableArray *)loadCategoriesFavorite;

+ (Categories *)getByParent:(NSInteger)parentId;
+ (Categories *)getById:(NSInteger)categoriesId;

@end
