//
//  AMButtonItem.m
//  Expenses
//

#import "AMButtonItem.h"

#import "UIColor-Expanded.h"

@implementation AMButtonItem

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	// Init image icon
	imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, self.frame.size.height - 2.0f)];
	[imageIcon setBackgroundColor:[UIColor clearColor]];
	[imageIcon setContentMode:UIViewContentModeCenter];
	[self addSubview:imageIcon];
	
	// Init image arrow
	imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 35.0f, 0.0f, 40.0f, self.frame.size.height - 2.0f)];
	[imageArrow setBackgroundColor:[UIColor clearColor]];
	[imageArrow setContentMode:UIViewContentModeCenter];
	[self addSubview:imageArrow];
	
	// Init label title
	labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(36.0f, 0.0f, self.frame.size.width / 2, self.frame.size.height - 2.0f)];
	[labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
	[labelTitle setTextColor:[UIColor colorWithHexString:@"3b3b3b"]];
	[labelTitle setHighlightedTextColor:[UIColor lightGrayColor]];
	[self addSubview:labelTitle];

	// Init label value
	labelValue = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0.0f, self.frame.size.width / 2 - 11.0f, self.frame.size.height - 2.0f)];
	[labelValue setBackgroundColor:[UIColor clearColor]];
	[labelValue setTextAlignment:UITextAlignmentRight];
	[labelValue setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
	[labelValue setTextColor:[UIColor colorWithHexString:@"3b3b3b"]];
	[labelValue setHighlightedTextColor:[UIColor lightGrayColor]];
	[self addSubview:labelValue];

}

#pragma mark -
#pragma mark Setters

- (void)setIcon:(UIImage *)icon {
	[imageIcon setImage:icon];
}

- (void)setArrow:(UIImage *)arrow {
	[imageArrow setImage:arrow];
	
	CGRect r = labelValue.frame;
	r.origin.x -= 15.0f;
	labelValue.frame = r;
}

- (void)setTitle:(NSString *)title {
	[labelTitle setText:title];
}

- (void)setValue:(NSString *)value {
	[labelValue setText:value];
}

- (void)setHighlighted:(BOOL)highlighted {
	[labelTitle setHighlighted:highlighted];
	[labelValue setHighlighted:highlighted];
	[super setHighlighted:highlighted];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	
	[labelTitle release];
	[labelValue release];
	[imageIcon release];
	[imageArrow release];
	
	[super dealloc];
}


@end
