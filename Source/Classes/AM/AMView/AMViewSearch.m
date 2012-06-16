//
//  AMViewSearch.m
//  Expenses
//
//  Created by Vinogradov Sergey on 18.05.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMViewSearch.h"

#import "Constants.h"

@interface AMViewSearch (Private)
- (void)textField:(UITextField *)_textField activate:(BOOL)active;
- (void)textFieldDidChange:(UITextField *)_textField;
@end

@implementation AMViewSearch

@synthesize isSearch, disabledHide, textField;

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	// Register notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.window];
	
	viewParent = [self superview];
	
	UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
	[imageBg setImage:[[UIImage imageNamed:@"background_searchbar.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0]];
	[self addSubview:imageBg];
	
	// Make overlay view
	viewOverlay = [[UIView alloc] initWithFrame:CGRectMake(viewParent.frame.origin.x, self.frame.origin.y + self.frame.size.height, viewParent.frame.size.width, viewParent.frame.size.height)];
	[viewOverlay setBackgroundColor:[UIColor blackColor]];
	[viewOverlay setAlpha:0];
	[viewParent addSubview:viewOverlay];
	
	// Init container
	view = [[UIView alloc] initWithFrame:CGRectMake(0.00f, 0.00f, self.frame.size.width, self.frame.size.height)];
	[view setBackgroundColor:[UIColor clearColor]];
	[self addSubview:view];
	
	// Init imageview
	imageViewBackground = [[UIImageView alloc] initWithFrame:view.frame];
	[imageViewBackground setImage:[[UIImage imageNamed:@"background_searchbar_textfield.png"] stretchableImageWithLeftCapWidth:35.00f topCapHeight:0.0f]];
	[imageViewBackground setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[view addSubview:imageViewBackground];
	
	// Init textfield
	textField = [[UITextField alloc] initWithFrame:CGRectMake(20.00f, 4.00f, 290.00f, 31.00f)];
	[textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[textField setDelegate:self];
	[textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
	[textField setTextColor:[UIColor blackColor]];
	[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[textField setPlaceholder:NSLocalizedString(@"search", @"Search")];
	[textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[textField setReturnKeyType:UIReturnKeySearch];
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField setCenter:CGPointMake(textField.center.x, view.center.y)];
	[view addSubview:textField];
	
	// Add button cancel
	buttonCancel = [AMButton withTypeButton:AMButtonTypeDefault];
	[buttonCancel setTitle:NSLocalizedString(@"cancel", @"Cancel") forState:UIControlStateNormal];
	[buttonCancel setFrame:CGRectMake(self.frame.size.width, buttonCancel.frame.origin.y, buttonCancel.frame.size.width, buttonCancel.frame.size.height)];
	[buttonCancel setCenter:CGPointMake(buttonCancel.center.x, view.frame.size.height / 2)];
	[buttonCancel addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:buttonCancel];
}

#pragma mark -
#pragma mark Actions

- (void)actionCancel {
	[self setActive:FALSE];
}

#pragma mark -
#pragma mark Set

- (void)setActive:(BOOL)active {
	if (!active) {
		isSearch = FALSE;
		textField.text = @"";
	}
	[self textField:textField activate:active];
}

#pragma mark -
#pragma mark UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)_textField {
	[[parent navigationController] setNavigationBarHidden:TRUE animated:TRUE];
	[_textField setClearButtonMode:UITextFieldViewModeAlways];
	[self textField:_textField activate:TRUE];
	
	if ([parent respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
		[parent performSelector:@selector(textFieldDidBeginEditing:) withObject:_textField];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)_textField {
	[[parent navigationController] setNavigationBarHidden:FALSE animated:TRUE];
	[_textField setClearButtonMode:UITextFieldViewModeNever];
	[self textField:_textField activate:FALSE];
	
	if ([parent respondsToSelector:@selector(textFieldDidEndEditing:)]) {
		[parent performSelector:@selector(textFieldDidEndEditing:) withObject:_textField];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)_textField {
	if ([parent respondsToSelector:@selector(textFieldShouldClear:)]) {
		[parent performSelector:@selector(textFieldShouldClear:) withObject:_textField];
	}
	return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
	if ([parent respondsToSelector:@selector(textFieldShouldReturn:)]) {
		[parent performSelector:@selector(textFieldShouldReturn:) withObject:_textField];
	}
	return TRUE;
}

- (BOOL)textField:(UITextField *)_textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return !(_textField.text.length >= LENGTH_MAX_SEARCH && range.length == 0);
}

- (void)textField:(UITextField *)_textField activate:(BOOL)active {	
    if (!active) {
		viewOverlay.alpha = 0;
		[viewOverlay removeFromSuperview];
		[_textField resignFirstResponder];
		
		[UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationCurveLinear animations:^{
			[buttonCancel setFrame:CGRectMake(self.frame.size.width, buttonCancel.frame.origin.y, buttonCancel.frame.size.width, buttonCancel.frame.size.height)];
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, self.frame.size.width, view.frame.size.height)];
		} 
		completion:^(BOOL finished) {
		}];
    } 
	else {
		[viewParent addSubview:viewOverlay];
		
		[UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationCurveLinear animations:^{
			viewOverlay.alpha = 0.5;
			[buttonCancel setFrame:CGRectMake(self.frame.size.width - buttonCancel.frame.size.width - 9.00f, buttonCancel.frame.origin.y, buttonCancel.frame.size.width, buttonCancel.frame.size.height)];
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, buttonCancel.frame.origin.x, view.frame.size.height)];
		} 
		completion:^(BOOL finished) {
		
		}];
	}
	
	if ([parent respondsToSelector:@selector(textField:activate:)]) {
		[parent performSelector:@selector(textField:activate:) withObject:textField withObject:[NSNumber numberWithBool:active]];
	}
	
	[self textFieldDidChange:_textField];
}

- (void)textFieldDidChange:(UITextField *)_textField {
	isSearch = (_textField.text.length) ? TRUE : FALSE;
	if ([parent respondsToSelector:@selector(textFieldDidChange:)]) {
		[parent performSelector:@selector(textFieldDidChange:) withObject:_textField];
	}
	if (disabledHide)
		return;
	if (isSearch) {
		[viewOverlay removeFromSuperview];
	}
	else {
		[viewParent addSubview:viewOverlay];
	}
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardDidShow:(NSNumber *)size {
	if ([parent respondsToSelector:@selector(keyboardDidShow:)])
		[parent performSelector:@selector(keyboardDidShow:) withObject:size];
}

- (void)keyboardDidHide:(NSNumber *)size {
	if ([parent respondsToSelector:@selector(keyboardDidHide:)])
		[parent performSelector:@selector(keyboardDidHide:) withObject:size];
}

- (void)keyboardWillShow:(NSNotification *)n {
	
	if (keyboardIsShown)
		return;
	
	CGRect _keyboardFrame;
	CGFloat _keyboardHeight;
	if (&UIKeyboardFrameEndUserInfoKey != nil)
        [[n.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardFrame];
	else
        [[n.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&_keyboardFrame];
	_keyboardHeight = _keyboardFrame.size.height;
	
	CGFloat size = 0 + _keyboardHeight;
	
	keyboardIsShown = YES;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self performSelector:@selector(keyboardDidShow:) withObject:[NSNumber numberWithFloat:size]];
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)n {
	if(!keyboardIsShown)
		return;
	
	CGRect _keyboardFrame;
	CGFloat _keyboardHeight;
	if (&UIKeyboardFrameEndUserInfoKey != nil)
        [[n.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardFrame];
	else
        [[n.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&_keyboardFrame];
	_keyboardHeight = _keyboardFrame.size.height;
	
	CGFloat size = 0 - _keyboardHeight;
	
	keyboardIsShown = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self performSelector:@selector(keyboardDidHide:) withObject:[NSNumber numberWithFloat:size]];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[viewParent release];
	[view release];
	[viewOverlay release];
	[textField release];
	[imageViewBackground release];
	[buttonCancel release];
    [super dealloc];
}

@end
