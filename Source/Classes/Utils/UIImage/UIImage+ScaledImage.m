//
//  UIImage+ScaledImage.m
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "UIImage+ScaledImage.h"

@implementation UIImage (ScaledImage)

+ (UIImage *)scaledImageNamed:(NSString *)name {
	UIImage *image = nil;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		// Seperate the string name into a path and extension
		NSString *path = [name stringByDeletingPathExtension];
		NSString *extension = [name pathExtension];
		
		// Build the iPad version of the filename
		// <path>-iPad.<extension>
		NSString *nameipad = [NSString stringWithFormat:@"%@-iPad.%@", path, extension];
		image = [UIImage imageNamed:nameipad];
	} 
	
	// Fallback to the standard version of the image
	if (!image) {
		image = [UIImage imageNamed:name];
	}
	
	return image;
}

@end
