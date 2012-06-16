//
//  DraggableViewController.h
//  AppsFilmzNew
//
//  Created by Dmitry Suhorukov on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableViewController : UIViewController
{
    UIButton* draggableHeaderView;
    UIButton* draggableCloseHeaderView;
    UIView* contentView;
    BOOL horizontal;
    BOOL closed;
    CGPoint touchPoint;
    BOOL isDragged;
    BOOL useAutoclose;
    NSTimeInterval autocloseInterval;
}

@property (nonatomic, retain) IBOutlet UIButton* draggableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton* draggableCloseHeaderView;
@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic) BOOL horizontal;
@property (nonatomic) BOOL closed;
@property (nonatomic) BOOL useAutoclose;
@property (nonatomic) NSTimeInterval autocloseInterval;

-(void) open;
-(void) close;
-(void) closeVertical;
-(void) openVertical;

@end
