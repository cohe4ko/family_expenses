//
//  SplashView.m
//  Expenses
//

#import "SplashView.h"

#import "UIColor-Expanded.h"

@implementation SplashView

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setFont:[UIFont fontWithName:@"LeckerliOneCTT" size:30]];
	[label setTextColor:[UIColor colorWithHexString:@"caa7a7"]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setShadowColor:[[[UIColor alloc] initWithRed:0.0 green:0 blue:0 alpha:0.4] autorelease]];
	[label setShadowOffset:CGSizeMake(0.00f, -1.00f)];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setText:NSLocalizedString(@"app_title", @"")];
	[label sizeToFit];
	[label setCenter:self.center];
	[self addSubview:label];
	[label release];
	
	labelVersion.text = [NSString stringWithFormat:NSLocalizedString(@"splash_version", @""), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[super dealloc];
}

@end
