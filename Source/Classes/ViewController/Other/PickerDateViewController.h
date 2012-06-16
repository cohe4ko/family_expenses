//
//  AddPickerDateViewController.h
//  Expenses
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

@interface PickerDateViewController : ViewController {
	IBOutlet UIView *viewOverlay;
	
	IBOutlet UIDatePicker *pickerView;
	
	IBOutlet UIButton *buttonDone;
	
	IBOutlet UILabel *labelHeader;
	
	id parent;
	SEL selector;
	
	NSDate *value;
	
	BOOL isLoaded;
}

@property (nonatomic, retain) id parent;
@property (nonatomic, retain) NSDate *value;
@property (nonatomic, assign) SEL selector;

- (IBAction)actionDone:(id)sender;

@end
