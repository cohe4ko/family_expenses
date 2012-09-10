//
//  AddViewController.m
//  Expenses
//

#import "AddViewController.h"
#import "AddEditViewController.h"
#import "CalculatorViewController.h"

#import "CategoriesController.h"
#import "Categories.h"

#import "MTLabel.h"

#import "DataManager.h"

@interface AddViewController (Private)
- (void)makeToolBar;
- (void)makeLocales;
- (void)makeItems;
- (void)makeCategories;
- (void)setData;
- (void)tilesWigglingStart;
- (void)tilesWigglingStop;
@end

@implementation AddViewController

@synthesize list;

#pragma mark -
#pragma mark Initializate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isShouldLoadEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Make toolbar
	[self makeToolBar];
	
	// Make locales
	[self makeLocales];
	
	// Make items
	[self makeItems];
	
	// Make categories
	[self makeCategories];
    
    if (list && [list count] == 0 && isShouldLoadEdit) {
        [self performSelector:@selector(actionEdit:) withObject:nil afterDelay:0.25f];
    }else {
        [[AppDelegate shared].tabBarController showTabBar:NO isPush:NO];
    }
    
    isShouldLoadEdit = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self tilesWigglingStop];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
	// Set right button
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_edit.png"] withSelector:@selector(actionEdit:)];
}

- (void)makeLocales {
	
	[labelHint setText:NSLocalizedString(@"add_hint", @"")];
}

- (void)makeItems {
	
	// Init tiles array
	tileFrame = [[NSMutableDictionary alloc] init];
	tileForFrame = [[NSMutableDictionary alloc] init];
	
	// Hide navigation shadow
	[imageNavigationbarShadow setHidden:YES];
    
    // Add the page control
	pageControl = [[DDPageControl alloc] init];
    [pageControl setFrame:CGRectMake(pageControl.frame.origin.x, scrollView.frame.size.height + 13.0f, pageControl.frame.size.width, pageControl.frame.size.height)];
	[pageControl setCenter:CGPointMake(self.view.center.x, pageControl.center.y)];
	[pageControl setCurrentPage:0];
	[pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
	[pageControl setDefersCurrentPageDisplay:YES] ;
	[pageControl setType:DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor:[UIColor colorWithHexString:@"6e8bab"]];
	[pageControl setOffColor:[UIColor colorWithHexString:@"cecece"]];
	[pageControl setIndicatorDiameter:6.0f];
	[pageControl setIndicatorSpace:6.0f];
	[self.view addSubview:pageControl];
}

- (void)makeCategories {
    
	// Remove old objects
	for (UIView *v in scrollView.subviews)
		[v removeFromSuperview];
	
	// Load categories
	self.list = [CategoriesController loadCategoriesFavorite];
	
	// Add categories
	float width = scrollView.frame.size.width;
	float p = 6.0f;
	float x = 4.0f;
	float y = 0.0f;
	float w = 94.0f;
	float h = 94.0f;
	
	int col = 0;
	int row = 0;
	int pages = 0;
	int idx = 0;
	
	for (Categories *item in list) {
		
		x = (width * pages) + (w * col) + (p * col) + 8.0f;
		y = (h * row);
		
		AddTileView *v = [[AddTileView alloc] initWithFrame:CGRectMake(x, y, w, h)];
		[v setBackgroundColor:[UIColor clearColor]];
		[v setParent:self];
		[v setIdx:idx];
		[v setItem:item];
		[scrollView addSubview:v];
		
		UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
		[longPressGesture setDelegate:self];
		[longPressGesture setMinimumPressDuration:0.5];
		[v addGestureRecognizer:longPressGesture];
		[longPressGesture release];
		
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
		[panRecognizer setMaximumNumberOfTouches:2];
		panRecognizer.cancelsTouchesInView = NO;
		[panRecognizer setDelegate:self];
		[v addGestureRecognizer:panRecognizer];
		[panRecognizer release];
		
		[tileFrame setObject:NSStringFromCGRect(v.frame) forKey:[NSNumber numberWithInt:idx]];
		[tileForFrame setObject:v forKey:[NSNumber numberWithInt:idx]];
		
		[v release];
		
		idx++;
		
		x += w + p;
		
		if (col++ == 2) {
			col = 0;
			row++;
		}
		if (row == 3) {
			row = 0;
			if (idx < [list count])
				pages++;
		}
	}
	
	// Set scrollview params
	[scrollView setContentSize:CGSizeMake(width * (pages + 1), scrollView.bounds.size.height)];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setPagingEnabled:YES];
	
	// Set pagecontrol params
	[pageControl setNumberOfPages:pages + 1];
}

#pragma mark -
#pragma mark UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer.view isKindOfClass:[AddTileView class]] && isAppear)
		return NO;
	return YES;
}

- (void)longTap:(UILongPressGestureRecognizer *)gestureRecognizer {
	
	AddTileView *tile = (AddTileView *)[gestureRecognizer view];
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		if (!isWiggling)
			[self tilesWigglingStart];
		[tile appearDraggable];
    }
	else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		[tile appearNormal];
	}
	else if ([gestureRecognizer state] == UIGestureRecognizerStateCancelled) {
		[self tileReset];
	}
}

- (void)move:(UIPanGestureRecognizer *)gestureRecognizer {
	
	if (!isWiggling)
		return;
	
	AddTileView *tile = (AddTileView *)[gestureRecognizer view];
	
	CGPoint translatedPoint = [gestureRecognizer locationInView:scrollView];
	
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		heldTile = tile;
		touchStartLocation = translatedPoint;
		heldStartPosition = tile.center;
		heldFrameIndex = [self frameIndexForTileIndex:tile.idx];
		
		[tile moveToFront];
		[tile appearDraggable];
	}
	else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		[self moveHeldTileToPoint:translatedPoint];
		[self moveUnheldTilesAwayFromPoint:translatedPoint];
	}
	else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		[UIView animateWithDuration:0.2 animations:^{
			heldTile.frame = CGRectFromString([tileFrame objectForKey:[NSNumber numberWithInt:heldFrameIndex]]);
		} completion:^(BOOL finished) {
			[heldTile appearNormal];
			heldTile = nil;
		}];
	}
	else if ([gestureRecognizer state] == UIGestureRecognizerStateCancelled) {
		[self tileReset];
	}
}

#pragma mark -
#pragma mark Tiles methods

- (void)setIsAppear:(NSNumber *)n {
	if (isAppear != [n boolValue]) {
		isAppear = [n intValue];
	}
}

- (void)moveHeldTileToPoint:(CGPoint)location {
    float dx = location.x - touchStartLocation.x;
    float dy = location.y - touchStartLocation.y;
    CGPoint newPosition = CGPointMake(heldStartPosition.x + dx, heldStartPosition.y + dy);
    
    heldTile.layer.position = newPosition;
}

- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location {
    int frameIndex = [self indexOfClosestFrameToPoint:location];
    if (frameIndex != heldFrameIndex) {
		
		[UIView animateWithDuration:0.3 animations:^{
			if (frameIndex < heldFrameIndex) {
				for (int i = heldFrameIndex; i > frameIndex; --i) {
					AddTileView *movingTile = [tileForFrame objectForKey:[NSNumber numberWithInt:i-1]];
					movingTile.frame = CGRectFromString([tileFrame objectForKey:[NSNumber numberWithInt:i]]);
					[tileForFrame setObject:movingTile forKey:[NSNumber numberWithInt:i]];
				}
			}
			else if (heldFrameIndex < frameIndex) {
				for (int i = heldFrameIndex; i < frameIndex; ++i) {
					AddTileView *movingTile = [tileForFrame objectForKey:[NSNumber numberWithInt:i+1]];
					movingTile.frame = CGRectFromString([tileFrame objectForKey:[NSNumber numberWithInt:i]]);
					[tileForFrame setObject:movingTile forKey:[NSNumber numberWithInt:i]];
				}
			}
		} completion:^(BOOL finished) {
			
		}];
		
		heldFrameIndex = frameIndex;
		[tileForFrame setObject:heldTile forKey:[NSNumber numberWithInt:heldFrameIndex]];
    }
    
    [self moveScroll];
}

- (void)moveScroll {
    float tileX = heldTile.frame.origin.x + heldTile.frame.size.width;
    float endX = (pageControl.currentPage + 1) * scrollView.frame.size.height + (heldTile.frame.size.width / 3);
    
    if (tileX > endX) {
        //[self pageControlPageSet:pageControl.currentPage + 1];
        //[pageControl setCurrentPage:pageControl.currentPage+1];
        //NSLog(@"tileX - %f", tileX);
        //NSLog(@"endX - %f", endX);
    }
}

- (int)indexOfClosestFrameToPoint:(CGPoint)point {
    int _index = 0;
    float minDist = FLT_MAX;
	
    for (int i = 0; i < [tileFrame count]; ++i) {
        CGRect frame = CGRectFromString([tileFrame objectForKey:[NSNumber numberWithInt:i]]);
		
        float dx = point.x - CGRectGetMidX(frame);
        float dy = point.y - CGRectGetMidY(frame);
        
        float dist = (dx * dx) + (dy * dy);
        if (dist < minDist) {
            _index = i;
            minDist = dist;
        }
    }
    return _index;
}

- (int)frameIndexForTileIndex:(int)tileIndex {
    for (int i = 0; i < [tileForFrame count]; ++i) {
		AddTileView *tile = [tileForFrame objectForKey:[NSNumber numberWithInt:i]];
        if (tile.idx == tileIndex) {
            return i;
		}
    }
    return 0;
}

#pragma mark -
#pragma mark Tile

- (void)tileReset {
	if (heldTile) {
		[UIView animateWithDuration:0.2 animations:^{
			heldTile.frame = CGRectFromString([tileFrame objectForKey:[NSNumber numberWithInt:heldFrameIndex]]);
		} completion:^(BOOL finished) {
			[heldTile appearNormal];
			heldTile = nil;
		}];
	}
}

- (void)tilesWigglingStart {
	for (NSNumber *n in tileForFrame) {
		AddTileView *tile = [tileForFrame objectForKey:n];
		[tile wigglingStart];
		for (UIGestureRecognizer *g in tile.gestureRecognizers) {
			if ([g isKindOfClass:[UILongPressGestureRecognizer class]]) {
				[(UILongPressGestureRecognizer *)g setMinimumPressDuration:0.2];
			}
		}
	}
	isWiggling = YES;
    
    // Set right button
    [self setButtonRight:NSLocalizedString(@"ok", @"") withSelector:@selector(actionDone)];
}

- (void)tilesWigglingStop {
    for (NSNumber *n in tileForFrame) {
		AddTileView *tile = [tileForFrame objectForKey:n];
		[tile wigglingStop];
		for (UIGestureRecognizer *g in tile.gestureRecognizers) {
			if ([g isKindOfClass:[UILongPressGestureRecognizer class]])
				[(UILongPressGestureRecognizer *)g setMinimumPressDuration:0.4];
		}
	}
	isWiggling = NO;
    
    // Save position
    [self tilesSavePosition];
    
    // Set right button
	[self setButtonRightWithImage:[UIImage imageNamed:@"icon_edit.png"] withSelector:@selector(actionEdit:)];
}

- (void)tileDelete:(AddTileView *)tile {
	
	for (Categories *m in [[DataManager shared].categories objectForKey:@"original"]) {
		if (m.Id == tile.item.Id)
			[m setIsFavorite:NO];
		for (Categories *mm in m.childs) {
			if (mm.Id == tile.item.Id)
				[mm setIsFavorite:NO];
		}
	}
	
	[tileForFrame removeObjectForKey:[NSNumber numberWithInt:tile.idx]];
	[tileFrame removeObjectForKey:[NSNumber numberWithInt:tile.idx]];
	[tile removeFromSuperview];
	
	// Add categories
	float width = scrollView.frame.size.width;
	float p = 6.0f;
	float x = 4.0f;
	float y = 0.0f;
	float w = 94.0f;
	float h = 94.0f;
	
	int col = 0;
	int row = 0;
	int pages = 0;
	int idx = 0;
	
	
	for (UIView *v in scrollView.subviews) {
		if ([v isKindOfClass:[AddTileView class]]) {
			AddTileView *t = (AddTileView *)v;
			
			x = (width * pages) + (w * col) + (p * col) + 8.0f;
			y = (h * row);
			
			[UIView animateWithDuration:0.3 animations:^{
				t.frame = CGRectMake(x, y, w, h);
			}];
			t.idx = idx;
			
			[tileFrame setObject:NSStringFromCGRect(t.frame) forKey:[NSNumber numberWithInt:idx]];
			[tileForFrame setObject:t forKey:[NSNumber numberWithInt:idx]];
			
			idx++;
			
			x += w + p;
			
			if (col++ == 2) {
				col = 0;
				row++;
			}
			if (row == 3) {
				row = 0;
				if (idx < [tileForFrame count])
					pages++;
			}
		}
	}
    
    // Save favorite
    [self tilesSaveFavorite];
}

- (void)tilesSaveFavorite {
    
    // Generate dic for save
	NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (NSNumber *n in tileForFrame) {
		AddTileView *tile = [tileForFrame objectForKey:n];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:tile.item.Id]];
    }
    
    // Save dic
	[[DataManager shared] saveDic:dic forKey:@"categories_favorite"];
}

- (void)tilesSavePosition {
    
    // Generate dic for save
	NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    for(int i = 0; i < [tileForFrame count]; ++i) {
		AddTileView *tile = [tileForFrame objectForKey:[NSNumber numberWithInt:i]];
        int idx = [self frameIndexForTileIndex:tile.idx];
        [dic setObject:[NSNumber numberWithInt:idx] forKey:[NSNumber numberWithInt:tile.item.Id]];
    }
    //}
    
    // Save dic
	[[DataManager shared] saveDic:dic forKey:@"categories_position"];
}

#pragma mark -
#pragma mark Actions

- (void)actionEdit:(AMButton *)button {
	AddEditViewController *controller = [MainController getViewController:@"AddEditViewController"];
	[controller setParent:self];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)actionNext:(UIButton *)button {
	CalculatorViewController *controller = [MainController getViewController:@"CalculatorViewController"];
	[controller setCategory:[list objectAtIndex:button.tag]];
	[controller setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionPage:(id)sender {
	
}

- (void)actionDone {
    [self tilesWigglingStop];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
}

#pragma mark -
#pragma mark DDPageControl triggered actions

- (void)pageControlPageSet:(int)page {
    pageControl.currentPage = page;
    [scrollView setContentOffset: CGPointMake(scrollView.bounds.size.width * pageControl.currentPage, scrollView.contentOffset.y) animated:YES] ;
}

- (void)pageControlClicked:(id)sender {
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	[self pageControlPageSet:thePageControl.currentPage];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	for (NSNumber *n in tileForFrame) {
		AddTileView *tile = [tileForFrame objectForKey:n];
        [tile appearNormal];
		[tile gestureCancel];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
	CGFloat pageWidth = scrollView.bounds.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
	
    if (pageControl.currentPage != nearestNumber) {
		pageControl.currentPage = nearestNumber;
        
		if (scrollView.dragging)
			[pageControl updateCurrentPageDisplay];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView {
	[pageControl updateCurrentPageDisplay] ;
}

#pragma mark -
#pragma mark Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	UIView *view = [touch view];
	
    if (![view isKindOfClass:[AddTileView class]] && isWiggling) {	
		[self tilesWigglingStop];
	}
	
	[super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[list release];
    [tileFrame release];
    [tileForFrame release];
    [heldTile release];
    [super dealloc];
}

@end