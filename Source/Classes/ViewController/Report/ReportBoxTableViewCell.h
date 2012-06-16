//
//  ReportBoxTableViewCell.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import "ReportBox.h"

@interface ReportBoxTableViewCell : UITableViewCell {
	IBOutlet UILabel *labelColor;
	IBOutlet UILabel *labelName;
	IBOutlet UILabel *labelAmount;
	
	ReportBox *item;
}

@property (nonatomic, retain) ReportBox *item;

@end
