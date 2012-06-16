//
//  SettingsController.h
//  Expenses
//
//  Created by Sergey Vinogradov on 18.11.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "MainController.h"

@interface SettingsController : MainController {

}

+ (id)withDelegate:(id)theDelegate;

+ (void)loadCategories;

@end
