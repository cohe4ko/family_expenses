//
//  BudgetTableViewCell.m
//  Expenses
//

#import "BudgetTableViewCell.h"
#import "BudgetViewController.h"

#import "UILabel+Utils.h"
#import "NSDate+Utils.h"

@interface BudgetTableViewCell (Private)
- (NSIndexPath *)indexPath;
- (void)setProgress;
@end

@implementation BudgetTableViewCell

@synthesize item, parent, edit;

#pragma mark -
#pragma mark Initializate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
	[self addSubview:viewDelete];
	CGRect r = viewDelete.frame;
	r.origin.x = self.frame.size.width;
	viewDelete.frame = r;
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
	[self.contentView addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];
	
	UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipe:)];
	[swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self.contentView addGestureRecognizer:swipeRecognizerLeft];
	[swipeRecognizerLeft release];
	
	UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipe:)];
	[swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.contentView addGestureRecognizer:swipeRecognizerRight];
	[swipeRecognizerRight release];
}

#pragma mark -
#pragma mark Set

- (void)setItem:(Budget *)_item {
	if (item != _item) {
		[item release];
		item = nil;
		item = [_item retain];
		
		// Set date
		[labelDate setText:[NSString stringWithFormat:@"%@ - %@", [item.dateFrom dateFormat:NSLocalizedString(@"budget_date_format", @"")], [item.dateTo dateFormat:NSLocalizedString(@"budget_date_format", @"")]]];
		
		// Set editing status
		[self setEdit:[[parent.cellEditing objectForKey:[NSNumber numberWithInteger:item.Id]] boolValue] animated:NO];
		
		// Set progress
		[self setProgress];
	}
    
    //always update currency
    if (item) {
        // Set label progress
		[labelProgress setText:[NSString stringWithFormat:@"%@ / %@", [item localizedTotal], [item localizedAmount]]];
    }
}

- (void)setProgress {
	
	[imageProgress setImage:item.progressImage];
	
	CGFloat totalWidth = imageProgressBackground.image.size.width - 4.0f;
	CGFloat width = totalWidth / 100.0f * item.progressPercent;
	if (width < 18.0f)
		width = 18.0f;
	if (width > totalWidth)
		width = totalWidth;
	CGRect r = imageProgress.frame;
	r.size.width = width;
	imageProgress.frame = r;
}

- (void)layoutSubviews {
	
	// Set editing status
	[self setEdit:[[parent.cellEditing objectForKey:[NSNumber numberWithInteger:item.Id]] boolValue] animated:NO];
	
	[super layoutSubviews];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionDelete:(id)sender {
	if ([parent respondsToSelector:@selector(tableView:didRemoveCellAtIndexPath:)])
		[parent performSelector:@selector(tableView:didRemoveCellAtIndexPath:) withObject:self.superview withObject:[self indexPath]];
}

#pragma mark -
#pragma mark UIGestureRecorgnizer

- (void)gestureTap:(UITapGestureRecognizer *)sender {
	if ([parent respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
		[parent performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:self.superview withObject:[self indexPath]];
}

- (void)gestureSwipe:(UISwipeGestureRecognizer *)sender {
	if (sender.direction == UISwipeGestureRecognizerDirectionLeft && !self.edit)
		[self setEdit:YES animated:YES];
	if (sender.direction == UISwipeGestureRecognizerDirectionRight && self.edit)
		[self setEdit:NO animated:YES];
	if ([parent respondsToSelector:@selector(tableView:willSwipeCellAtIndexPath:)])
		[parent performSelector:@selector(tableView:willSwipeCellAtIndexPath:) withObject:self.superview withObject:[self indexPath]];
}

#pragma mark -
#pragma mark Getters

- (NSIndexPath *)indexPath {
	return [(UITableView *)self.superview indexPathForCell:self];
}

#pragma mark -
#pragma mark Setters

- (void)setEdit:(BOOL)_edit animated:(BOOL)animated {	
	if (edit != _edit) {
		edit = _edit;
		
		// Save editing state
		[parent.cellEditing setObject:[NSNumber numberWithBool:edit] forKey:[NSNumber numberWithInteger:item.Id]];
		
		[UIView animateWithDuration:((animated) ? 0.3f : 0.0f) animations:^{
			
			[imageProgressBackground setImage:((edit) ? [UIImage imageNamed:@"budget_progress_background_edit.png"] : [UIImage imageNamed:@"budget_progress_background.png"])];
			
			CGRect r = viewContent.frame;
			r.size.width = (edit) ? 255.0f : 310.0f;
			viewContent.frame = r;
			
			r = viewDelete.frame;
			r.origin.x = (edit) ? self.frame.size.width - r.size.width : self.frame.size.width;
			viewDelete.frame = r;
			
			[self setProgress];
			
		} completion:^(BOOL finished) {
		}];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[item release];
	[parent release];
	[labelDate release];
	[labelPrice release];
	[viewDelete release];
	[buttonDelete release];
	[viewContent release];
	[imageProgress release];
	[labelProgress release];
	[imageProgressBackground release];
    [super dealloc];
}

@end