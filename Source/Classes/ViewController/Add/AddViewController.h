//
//  AddViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "AddTileView.h"
#import "AMScrollView.h"

#import "DDPageControl.h"

@interface AddViewController : ViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
	IBOutlet AMScrollView *scrollView;
	
	IBOutlet UILabel *labelHint;
	
    DDPageControl *pageControl;
	
	NSMutableArray *list;
	
	NSMutableDictionary *tileFrame;
    NSMutableDictionary *tileForFrame;
	
    int heldFrameIndex;
	
    CGPoint heldStartPosition;
    CGPoint touchStartLocation;
	
	AddTileView *heldTile;
	
	BOOL isWiggling;
	BOOL isAppear;
	BOOL isDragging;
    BOOL isShouldLoadEdit;
}

@property (nonatomic, retain) NSMutableArray *list;

- (IBAction)actionPage:(id)sender;
- (void)updateTabBar;

@end
