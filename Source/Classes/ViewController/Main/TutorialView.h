//
//  TutorialView.h
//  Expenses
//
//  Created by Ruslan on 28.09.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "DDPageControl.h"

@interface TutorialView : UIView<UIScrollViewDelegate>{
    UIView *view;
    UIScrollView *scrollView;
    DDPageControl *pageControl;
    NSArray *imageArray;
}

- (void)onClose:(void (^)(void)) onCloseBlock;

- (void)setImages:(NSArray*)images;

- (void)showOnView:(UIView*)sview animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
