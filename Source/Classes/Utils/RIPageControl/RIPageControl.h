//
//  RIPageControl.h
//  CostApp
//
//  Created by Ruslan on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIPageControl : UIView{
    UIColor *color1;
    UIColor *color2;
    NSInteger numberOfPages;
    NSInteger currentPage;
}

@property(nonatomic,readwrite)NSInteger numberOfPages;
@property(nonatomic,readwrite)NSInteger currentPage;

-(void)changeColors:(UIColor*)newColor1 forSec:(UIColor*)newColor2;

@end
