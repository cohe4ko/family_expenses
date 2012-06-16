//
//  AMButtonItem.h
//  Expenses
//

#import <UIKit/UIKit.h>

@interface AMButtonItem : UIButton {
	
	UIImageView *imageIcon;
	UIImageView *imageArrow;
	
	UILabel *labelTitle;
	UILabel *labelValue;
}

- (void)setIcon:(UIImage *)icon;
- (void)setArrow:(UIImage *)arrow;
- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value;

@end
