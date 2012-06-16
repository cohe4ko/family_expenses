//
//  AddTileView.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Categories.h"

@interface AddTileView : UIView {
	
	UIView *viewContent;
	
	UIImageView *imageViewEdit;
	
	UIButton *buttonAction;
	UIButton *buttonDelete;
	
	Categories *item;
	
	id parent;
	
	int idx;
}

@property (nonatomic, retain) Categories *item;
@property (nonatomic, retain) id parent;
@property (nonatomic, assign) int idx;

- (void)appearNormal;
- (void)appearDraggable;

- (void)wigglingStart;
- (void)wigglingStop;

- (void)moveToFront;

- (void)gestureCancel;

@end
