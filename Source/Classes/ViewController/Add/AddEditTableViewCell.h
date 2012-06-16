//
//  AddEditTableViewCell.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "Categories.h"

@interface AddEditTableViewCell : UITableViewCell {
	
	IBOutlet UIView *viewContent;
	
	IBOutlet UIImageView *imageBackground;
	IBOutlet UIImageView *imageArrow;
	IBOutlet UIImageView *imageIcon;
	
	IBOutlet UIButton *buttonRow;
	IBOutlet UIButton *buttonCheckbox;
	
	IBOutlet UILabel *labelName;
	
	Categories *item;
	
	id parent;
	
	BOOL isLast;
}

@property (nonatomic, retain) Categories *item;
@property (nonatomic, retain) id parent;
@property (nonatomic, assign) BOOL isLast;

- (IBAction)actionRow:(id)sender;
- (IBAction)actionRowCheck:(id)sender;


@end
