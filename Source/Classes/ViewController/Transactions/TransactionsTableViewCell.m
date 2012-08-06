//
//  TransactionsTableViewCell.m
//  Expenses
//

#import "TransactionsTableViewCell.h"
#import "TransactionsViewController.h"

#import "UILabel+Utils.h"
#import "NSDate+Utils.h"
#import "NSLocale+Currency.h"

@interface TransactionsTableViewCell (Private)
- (NSIndexPath *)indexPath;
@end

@implementation TransactionsTableViewCell

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

- (void)setItem:(Transactions *)_item {
	if (item != _item) {
		[item release];
		item = nil;
		item = [_item retain];
		
		CGRect r;
		
		// Set icon
		[imageViewIcon setImage:item.categories.imageNormal];
		
		// Set desc
		[labelDesc setText:item.desc];
		[labelDesc sizeToFit];
		r = labelDesc.frame;
		r.size.width = 140.0f;
		r.size.height = 18.0f;
		r.origin.y = self.frame.size.height / 2 - r.size.height / 2;
		labelDesc.frame = r;
		
		// Set categories
		[labelCategories setText:item.categories.name];
		[labelCategories sizeToFit];
		r = labelCategories.frame;
		r.origin.y = labelDesc.frame.origin.y - r.size.height - 0.0f;
		labelCategories.frame = r;
		
		// Set date
		[labelDate setText:[item.date dateFormat:NSLocalizedString(@"transactions_date_format", @"")]];
		[labelDate sizeToFit];
		r = labelDate.frame;
		r.origin.y = labelDesc.frame.origin.y + labelDesc.frame.size.height;
		labelDate.frame = r;
		
				
		// Set repeat icon
		[imageViewRepeat setHidden:!item.isRepeat];
		[imageViewRepeat setCenter:CGPointMake(imageViewRepeat.center.x, labelDate.center.y)];
		r = imageViewRepeat.frame;
		r.origin.x = labelDate.frame.origin.x + labelDate.frame.size.width + 3.0f;
		imageViewRepeat.frame = r;
	}
    
    // Set price
    NSString *countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings_country_code"];
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_points"]-1;
    [labelPrice setText:[item priceForCurrency:[NSLocale currencyCodeForCountryCode:countryCode] points:points]];
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
			CGRect r = viewContent.frame;
			r.origin.x = (edit) ? -55.0f : 0.0f;
			viewContent.frame = r;
			
			r = viewDelete.frame;
			r.origin.x = (edit) ? self.frame.size.width - r.size.width : self.frame.size.width;
			viewDelete.frame = r;
		}];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
    self.item = nil;
	self.parent = nil;
    
    if (imageViewIcon) {
        [imageViewIcon release];
        imageViewIcon = nil;
    }
    if (labelCategories) {
        [labelCategories release];
        labelCategories = nil;
    }
    if (labelDesc) {
        [labelDesc release];
        labelDesc = nil;
    }
	if (labelDate) {
        [labelDate release];
        labelDate = nil;
    }
	if (labelPrice) {
        [labelPrice release];
        labelPrice = nil;
    }
	if (imageViewRepeat) {
        [imageViewRepeat release];
        imageViewRepeat = nil;
    }
	if (viewDelete) {
      	[viewDelete release];
        viewDelete = nil;
    }
	if (buttonDelete) {
      	[buttonDelete release];
        buttonDelete = nil;
    }
    if (viewContent) {
        [viewContent release];
        viewContent = nil;
    }

	
    
    [super dealloc];
}

@end