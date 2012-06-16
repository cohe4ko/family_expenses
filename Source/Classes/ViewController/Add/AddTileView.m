//
//  AddTileView.m
//  Expenses
//

#import "AddTileView.h"
#import "MTLabel.h"

@implementation AddTileView

@synthesize item, parent, idx;

#pragma mark -
#pragma mark Initializate

- (id)initWithFrame:(CGRect)frame {
	if (self == [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

#pragma mark -
#pragma mark Set

- (void)setItem:(Categories *)_item {
	if (item != _item) {
		[item release];
		item = [_item retain];
		
		float w = self.frame.size.width;
		float h = self.frame.size.height;
		
		viewContent = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, w, h)];
		[viewContent setBackgroundColor:[UIColor clearColor]];
		[self addSubview:viewContent];
		
		
		buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 2.0f, w, h)];
		[buttonAction setImage:item.imageBordered forState:UIControlStateNormal];
		[buttonAction setImage:item.imageBordered forState:UIControlStateDisabled];
		[buttonAction setBackgroundColor:[UIColor clearColor]];
		[buttonAction setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 25.0f, 0.0f)];
		[buttonAction setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
		[buttonAction setTag:idx];
		[buttonAction addTarget:parent action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
		[viewContent addSubview:buttonAction];
		[buttonAction release];
		
		MTLabel *label;
		
		float addY = (item.name.length < 18.0f) ? 4.0f : 0.0f;
		label = [[MTLabel alloc] initWithFrame:CGRectMake(5.0f, 69.0f + addY, 84.0f, 23.0f)];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setAdjustSizeToFit:YES];
		[label setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
		[label setFontColor:[UIColor whiteColor]];
		[label setLineHeight:10.0f];
		[label setText:item.name];
		[label setTextAlignment:MTLabelTextAlignmentCenter];
		[viewContent addSubview:label];
		[label release];
		
		label = [[MTLabel alloc] initWithFrame:CGRectMake(5.0f, 68.0f + addY, 84.0f, 23.0f)];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
		[label setFontColor:[UIColor blackColor]];
		[label setLineHeight:10.0f];
		[label setText:item.name];
		[label setTextAlignment:MTLabelTextAlignmentCenter];
		[viewContent addSubview:label];
		[label release];
		
		imageViewEdit = [[UIImageView alloc] initWithFrame:CGRectMake(w / 2 - 44.0f, 6.0f, 88.0f, 88.0f)];
		[imageViewEdit setUserInteractionEnabled:NO];
		[imageViewEdit setImage:[UIImage imageNamed:@"background_category_edit.png"]];
		[imageViewEdit setHidden:YES];
		[viewContent addSubview:imageViewEdit];
		[viewContent sendSubviewToBack:imageViewEdit];
		
		buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonDelete setFrame:CGRectMake(w - 29.0f, 0.0f, 29.0f, 29.0f)];
		[buttonDelete setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
		[buttonDelete setHidden:YES];
		[buttonDelete addTarget:self action:@selector(actionDeleteTouchDown) forControlEvents:UIControlEventTouchDown];
		[buttonDelete addTarget:self action:@selector(actionDelete) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:buttonDelete];
	}
}

- (void)appearNormal {
	[parent performSelector:@selector(setIsAppear:) withObject:[NSNumber numberWithBool:NO]];
	[UIView animateWithDuration:0.1 animations:^{
		self.layer.opacity = 1.0;
		[self.layer setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"transform.scale"];
	} completion:^(BOOL finished) {
	}];
}

- (void)appearDraggable {
	[parent performSelector:@selector(setIsAppear:) withObject:[NSNumber numberWithBool:YES]];
	[UIView animateWithDuration:0.1 animations:^{
		self.layer.opacity = 0.8;
		[self.layer setValue:[NSNumber numberWithFloat:1.1] forKeyPath:@"transform.scale"];
	} completion:^(BOOL finished) {
	}];
}

- (void)wigglingStart {
	CAKeyframeAnimation *anim;
	
	anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.02], [NSNumber numberWithFloat:0.02], nil];
    anim.duration = 0.11f + ((idx % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    [self.layer addAnimation:anim forKey:@"wiggleRotation"];
    
    anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1.0], [NSNumber numberWithFloat:1.0], nil];
    anim.duration = 0.9f + ((idx % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.additive = YES;
    [self.layer addAnimation:anim forKey:@"wiggleTranslationY"];
	
	[imageViewEdit setHidden:NO];
	[buttonDelete setHidden:NO];
	
	[viewContent setUserInteractionEnabled:NO];
}

- (void)wigglingStop {
	[self.layer removeAnimationForKey:@"wiggleRotation"];
    [self.layer removeAnimationForKey:@"wiggleTranslationY"];
	
	[imageViewEdit setHidden:YES];
	[buttonDelete setHidden:YES];
	
	[viewContent setUserInteractionEnabled:YES];
}

- (void)moveToFront {
	[self.superview bringSubviewToFront:self];
}

- (void)gestureCancel {
	for (UIGestureRecognizer *g in self.gestureRecognizers) {
		[g setEnabled:NO];
		[g setEnabled:YES];
	}
}

#pragma mark -
#pragma mark Actions

- (void)actionDeleteTouchDown {
	[self gestureCancel];
}

- (void)actionDelete {
	[parent performSelector:@selector(tileDelete:) withObject:self];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[item release];
	[parent release];
	[super dealloc];
}

@end
