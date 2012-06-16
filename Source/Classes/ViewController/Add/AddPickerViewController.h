//
//  AddPickerViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

typedef enum {
    PickerTypeWeek	= 0,
	PickerTypeMonth = 1,
} PickerType;

@interface AddPickerViewController : ViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	
	IBOutlet UIView *viewOverlay;
	
	IBOutlet UIPickerView *pickerView;
	
	IBOutlet UIButton *buttonLeft;
	IBOutlet UIButton *buttonRight;
	IBOutlet UIButton *buttonDone;
	
	IBOutlet UILabel *labelHeader;
	
	PickerType pickerType;
	
	id parent;
	
	NSMutableArray *list;
	
	NSNumber *value;
	
	BOOL isLoaded;
}

@property (nonatomic, assign) PickerType pickerType;
@property (nonatomic, retain) id parent;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSNumber *value;

- (IBAction)actionSwitch:(UIButton *)sender;
- (IBAction)actionDone:(id)sender;

@end
