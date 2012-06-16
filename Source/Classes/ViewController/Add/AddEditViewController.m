//
//  AddEditViewController.m
//  Expenses
//

#import "AddEditViewController.h"
#import "CategoriesController.h"

#import "Categories.h"

@interface AddEditViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)setData;
@end

@implementation AddEditViewController

@synthesize parent;

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make toolbar
	[self makeToolBar];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Set button back
	[self setButtonBack:NSLocalizedString(@"back", @"Back")];
}

- (void)makeLocales {
	
	[labelHint setText:NSLocalizedString(@"add_edit_hint", @"")];
	[buttonDone setTitle:NSLocalizedString(@"add_edit_button_done", @"Done") forState:UIControlStateNormal];
}

- (void)makeItems {
	list = [[NSMutableArray alloc] init];
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		[list addObject:[[m copy] autorelease]];
	}
}

#pragma mark -
#pragma mark Actions

- (void)actionRow:(Categories *)item {
	
	// Deselect rows
	for (Categories *m in list) {
		if (m != item)
			[m setIsSelected:NO];
	}
		
	// Update rows height
	[tableView beginUpdates];
	[tableView endUpdates];
	
	// Scroll to selected row
	int idx = [list indexOfObject:item];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (IBAction)actionDone:(id)sender {
    
    NSMutableDictionary *oldCat = [[NSMutableDictionary alloc] init];
    int lastPosition = 0;
    for (Categories *c in [CategoriesController loadCategoriesFavorite]) {
        if (c.position > lastPosition)
            lastPosition = c.position;
        [oldCat setObject:[NSNumber numberWithInt:c.position] forKey:[NSNumber numberWithInt:c.Id]];
    }
    
	// Generate dic for save
	NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
	for (Categories *m in list) {
		[dic setObject:[NSNumber numberWithBool:m.isFavorite] forKey:[NSNumber numberWithInt:m.Id]];
        if (m.isFavorite) {
            if (![oldCat objectForKey:[NSNumber numberWithInt:m.Id]]) {
                [oldCat setObject:[NSNumber numberWithInt:-1] forKey:[NSNumber numberWithInt:m.Id]];
            }
        }
		for (Categories *mm in m.childs) {
			[dic setObject:[NSNumber numberWithBool:mm.isFavorite] forKey:[NSNumber numberWithInt:mm.Id]];
            if (mm.isFavorite) {
                if (![oldCat objectForKey:[NSNumber numberWithInt:mm.Id]]) {
                    [oldCat setObject:[NSNumber numberWithInt:-1] forKey:[NSNumber numberWithInt:mm.Id]];
                }
            }
        }
	}
    
	// Save dic
	[[DataManager shared] saveDic:dic forKey:@"categories_favorite"];
    
    NSMutableDictionary *dicPosition = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSNumber *n in oldCat) {
        int pos = [[oldCat objectForKey:n] intValue];
        if (pos < 0)
            pos = ++lastPosition;
        [dicPosition setObject:[NSNumber numberWithInt:pos] forKey:n];
    }
    
    // Save position
    [[DataManager shared] saveDic:dicPosition forKey:@"categories_position"];
	
	// Set favorite state for original list categories
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		[m setIsFavorite:[[dic objectForKey:[NSNumber numberWithInt:m.Id]] boolValue]];
		for (Categories *mm in m.childs)
			[mm setIsFavorite:[[dic objectForKey:[NSNumber numberWithInt:mm.Id]] boolValue]];
	}
	
	// Reload categories
	[parent performSelector:@selector(makeCategories)];
	
	// Go back
	[self actionBack];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)viewDidUnload {
	[tableView release];
	tableView = nil;
	[labelHint release]; 
	labelHint = nil;
	[list release];
	list = nil;
	[buttonDone release];
	buttonDone = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[tableView release];
	[labelHint release];
	[buttonDone release];
	[parent release];
    [super dealloc];
}

@end