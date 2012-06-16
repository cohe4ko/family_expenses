//
//  UIImage-Extensions.h
//  Expenses
//
//  Created by Vinogradov Sergey on 03.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extensions)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
