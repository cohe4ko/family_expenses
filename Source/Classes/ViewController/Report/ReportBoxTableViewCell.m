//
//  ReportBoxTableViewCell.m
//  Expenses
//

#import "ReportBoxTableViewCell.h"

#import "UIColor-Expanded.h"

@implementation ReportBoxTableViewCell

@synthesize item;

#pragma mark -
#pragma mark Initializate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark Set

- (void)setItem:(ReportBox *)_item {
	if (item != _item) {
		[item release];
		item = nil;
		item = [_item retain];
		
		// Set color
		[labelColor setBackgroundColor:[UIColor colorWithHexString:item.color]];
		
		// Set name
		[labelName setText:item.name];
		
		// Set amount
		[labelAmount setText:item.amountString];
	}
}

#pragma mark -
#pragma mark Other

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[item release];
	[labelColor release];
	[labelName release];
	[labelAmount release];
    [super dealloc];
}

@end