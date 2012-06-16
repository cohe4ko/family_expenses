//
//  AddEditTableViewCell.m
//  Expenses
//

#import "AddEditTableViewCell.h"

#import "UIColor-Expanded.h"

@interface AddEditTableViewCell (Private)
- (void)setBackgroundImage;
@end

@implementation AddEditTableViewCell

@synthesize item, parent;

#pragma mark -
#pragma mark Initializate

@synthesize isLast;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark Set

- (void)setItem:(Categories *)_item {
	if (item != _item) {
		[item release];
		item = nil;
		item = [_item retain];
		
		// Set icon
		[imageIcon setImage:item.imageNormal];
		
		// Set name
		[labelName setText:item.name];
		
		// Set background
		[self setBackgroundImage];
		
		// Set checked
		[buttonCheckbox setSelected:item.isFavorite];
		
		// Make items
		float y = 0.0f;
		
		// Create view
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.0f, buttonRow.frame.origin.y + buttonRow.frame.size.height, self.frame.size.width, 0.0f)];
		[v setBackgroundColor:[UIColor clearColor]];
		[v setClipsToBounds:YES];
		
		// Add items to view
		for (Categories *m in item.childs) {
			
			// Add button
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, y, 320.0f, 46.0f)];
			[button setAdjustsImageWhenHighlighted:NO];
			[button setBackgroundImage:[UIImage imageNamed:@"table_row_item.png"] forState:UIControlStateNormal];
			[v addSubview:button];
			
			// Add icon
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, y + 8, 30.0f, 30.0f)];
			[imageView setContentMode:UIViewContentModeScaleAspectFit];
			[imageView setImage:m.imageNormal];
			[v addSubview:imageView];
			[imageView release];
			
			// Add label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, y, 204.0f, 46.0f)];
			[label setBackgroundColor:[UIColor clearColor]];
			[label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
			[label setTextColor:[UIColor colorWithHexString:@"3b3b3b"]];
			[label setText:m.name];
			[v addSubview:label];
			[label release];
			
			// Add button checkbox
			UIButton *buttonC = [[UIButton alloc] initWithFrame:CGRectMake(266.0f, y, 50.0f, 46.0f)];
			[buttonC setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
			[buttonC setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
			[buttonC setTag:m.Id];
			[buttonC setSelected:m.isFavorite];
			[buttonC addTarget:self action:@selector(actionItemCheck:) forControlEvents:UIControlEventTouchUpInside];
			[v addSubview:buttonC];
			[buttonC release];
			
			y += button.frame.size.height;
			[button release];
		}
		
		// Add top shadow
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_row_shadow_top.png"]];
		[v addSubview:imageView];
		[imageView release];
		
		// Add top shadow
		if (!isLast) {
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_row_shadow_bottom.png"]];
			[imageView setFrame:CGRectMake(0.0f, y - imageView.frame.size.height, imageView.frame.size.width, imageView.frame.size.height)];
			[v addSubview:imageView];
			[imageView release];
		}
		
		CGRect r = v.frame;
		r.size.height = y;
		v.frame = r;
		[viewContent addSubview:v];
		[v release];
	}
}

- (void)setBackgroundImage {
	NSString *imageName = @"";
	if (isLast && !item.isSelected) {
		imageName = @"table_row_header_last.png";
	}
	else {
		imageName = @"table_row_header.png";
	}
	[buttonRow setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionRow:(id)sender {
	item.isSelected = !item.isSelected;
	
	// Change image arrow state
	[imageArrow setHighlighted:item.isSelected];
	
	// Resize tableview row height
	[parent performSelector:@selector(actionRow:) withObject:item];
	
	// Change background image
	if (isLast)
		[self setBackgroundImage];
}

- (IBAction)actionRowCheck:(id)sender {
	buttonCheckbox.selected = !buttonCheckbox.selected;
	[item setIsFavorite:buttonCheckbox.selected];
}

- (void)actionItemCheck:(UIButton *)sender {
	sender.selected = !sender.selected;
	for (Categories *m in item.childs) {
		if (m.Id == sender.tag) {
			[m setIsFavorite:sender.selected];
		}
	}
	//[(Category *)[viewContent viewWithTag:sender.tag] setIsFavorite:sender.selected];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[item release];
	[imageBackground release];
	[buttonRow release];
	[imageArrow release];
	[viewContent release];
	[buttonCheckbox release];
	[imageIcon release];
	[labelName release];
    [super dealloc];
}

@end