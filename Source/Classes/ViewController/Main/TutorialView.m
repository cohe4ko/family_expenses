//
//  TutorialView.m
//  Expenses
//
//  Created by Ruslan on 28.09.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "TutorialView.h"
#import "UIColor-Expanded.h"

@interface TutorialView()
@property (nonatomic,copy) void (^onClose)();

- (void)updateScrollView;
- (void)updateScrollViewPosition;
@end

#define TUTORIAL_PADDING 10.0

@implementation TutorialView
@synthesize onClose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        view = [[UIView alloc] initWithFrame:CGRectMake(TUTORIAL_PADDING, TUTORIAL_PADDING, frame.size.width-2*TUTORIAL_PADDING, frame.size.height-2*TUTORIAL_PADDING)];
		view.backgroundColor = [UIColor blackColor];
		view.layer.masksToBounds = YES;
		view.layer.cornerRadius = 10.0;
		view.alpha = 0.8;
		[self addSubview:view];
        [view release];
        
                
        pageControl = [[DDPageControl alloc] init];
        [pageControl setFrame:CGRectMake(roundf(view.frame.size.width/2.0-pageControl.frame.size.width/2.0), view.frame.size.height-pageControl.frame.size.height, pageControl.frame.size.width, pageControl.frame.size.height)];
        [pageControl setDefersCurrentPageDisplay:YES];
        [pageControl setType:DDPageControlTypeOnFullOffEmpty] ;
        [pageControl setOnColor:[UIColor colorWithHexString:@"6e8bab"]];
        [pageControl setOffColor:[UIColor colorWithHexString:@"cecece"]];
        [pageControl setCurrentPage:0];
        [pageControl setIndicatorDiameter:6.0f];
        [pageControl setIndicatorSpace:6.0f];
        [view addSubview:pageControl];
        [pageControl release];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-pageControl.frame.size.height)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [view addSubview:scrollView];
        [scrollView release];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *closeImage = [UIImage imageNamed:@"icon_close.png"];
        closeButton.frame = CGRectMake(roundf(frame.size.width-TUTORIAL_PADDING/2.0-closeImage.size.width), roundf(TUTORIAL_PADDING/2.0), closeImage.size.width, closeImage.size.height);
        [closeButton addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [self addSubview:closeButton];
    }
    return self;
}

- (void)onClose:(void (^)(void)) onCloseBlock{
    self.onClose = onCloseBlock;
}

- (void)showOnView:(UIView*)sview animated:(BOOL)animated{
    if (animated) {
        self.alpha = 0.0;
        [sview addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
    }else{
        [sview addSubview:self];
    }

}

- (void)hideAnimated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished){
            if (self.onClose) {
                self.onClose();
            }
            [self removeFromSuperview];
        }];
    }else{
        if (self.onClose) {
            self.onClose();
        }
        [self removeFromSuperview];
    }
}

- (void)setImages:(NSArray*)images{
    if (imageArray) {
        [imageArray release];
        imageArray = nil;
    }
    if (images) {
        imageArray = [[NSArray alloc] initWithArray:images];
    }
    [self updateScrollView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc{
    if (imageArray) {
        [imageArray release];
        imageArray = nil;
    }
    self.onClose = nil;
    [super dealloc];
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self updateScrollViewPosition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateScrollViewPosition];
}

- (void)updateScrollViewPosition{
    if (imageArray) {
        NSInteger index = 0;
        if (scrollView.contentOffset.x >= 0) {
            index = (NSInteger)(scrollView.contentOffset.x)/(NSInteger)(scrollView.frame.size.width);
            if ((scrollView.contentOffset.x-index*scrollView.frame.size.width > round(scrollView.frame.size.width)) && index < [imageArray count] - 1) {
                index++;
            }
        }
        [scrollView scrollRectToVisible:CGRectMake(index*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        [pageControl setCurrentPage:index];
        [pageControl updateCurrentPageDisplay];
    }

}

#pragma mark -

#pragma mark Private


- (void)updateScrollView{
    CGFloat contentSizeWidth = 0;
    CGFloat paddingX = 10.0;
    for (UIView *v in [scrollView subviews]) {
        if (v.tag > 0) {
            [v removeFromSuperview];
        }
    }
    
    if (imageArray) {
        for (int i = 0; i < [imageArray count]; i++) {
            UIImage *image = [imageArray objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentSizeWidth+paddingX, paddingX, scrollView.frame.size.width-2*paddingX, scrollView.frame.size.height-paddingX)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = image;
            imageView.tag = i+1;
            [scrollView addSubview:imageView];
            [imageView release];
            contentSizeWidth += scrollView.frame.size.width;
        }
        [pageControl setNumberOfPages:[imageArray count]];
    }
    scrollView.contentSize = CGSizeMake(contentSizeWidth, scrollView.frame.size.height);
}

/*- (void)redraw:(UIInterfaceOrientation)interfaceOrientation{
    [super redraw:interfaceOrientation];
    pageControl.frame = CGRectMake(roundf(view.frame.size.width/2.0-pageControl.frame.size.width/2.0), view.frame.size.height-pageControl.frame.size.height, pageControl.frame.size.width, pageControl.frame.size.height);
    scrollView.frame = CGRectMake(0, label.frame.origin.y, view.frame.size.width, view.frame.size.height-label.frame.size.height-pageControl.frame.size.height);
    [self updateScrollView];
}*/

#pragma mark -

#pragma mark -
#pragma mark Action

- (void)actionClose{
    [self hideAnimated:YES];
}


@end
