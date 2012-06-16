//
//  DraggableViewController.m
//  AppsFilmzNew
//
//  Created by Dmitry Suhorukov on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DraggableViewController.h"

@implementation DraggableViewController
@synthesize draggableHeaderView, draggableCloseHeaderView, horizontal, contentView, useAutoclose, autocloseInterval, closed;

-(void) dealloc
{
    [contentView release];
    [draggableHeaderView release];
    [draggableCloseHeaderView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    autocloseInterval = 5.0f;
    
    closed = YES;
    
    CGFloat headerHeight = draggableHeaderView.frame.size.height;
    CGFloat headerWidth = draggableHeaderView.frame.size.width;
    CGRect f = self.view.frame;
    
    if(!horizontal)
        f.origin.y = self.view.superview.frame.size.height - headerHeight;
    else
        f.origin.x = -f.size.width + headerWidth;
    
    self.view.frame = f;
    
    draggableCloseHeaderView.frame = draggableHeaderView.frame;
    
    [self.view bringSubviewToFront:draggableHeaderView];
    [self close];
	
	// Fix table view frame
	f = contentView.frame;
	f.size.height -= 8.0f;
	contentView.frame = f;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (IBAction)dragBegan:(UIControl *)c withEvent:ev {
    
    UITouch *touch = [[ev allTouches] anyObject];
    touchPoint = [touch locationInView:self.view.superview];
    isDragged = NO;
}

- (IBAction)dragMoving:(UIControl *)c withEvent:ev {
    
    isDragged = YES;
    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint dragPoint = [touch locationInView:self.view.superview];
    
    [UIView beginAnimations:@"dragging" context:self];
    if(horizontal)
    {
        CGFloat tx = self.view.transform.tx;
        if(tx <= self.view.frame.size.width - draggableHeaderView.frame.size.width)
        {
            if(closed)
            {
                self.view.transform = CGAffineTransformMakeTranslation(dragPoint.x - touchPoint.x,0);
            }
            else
            {
                tx = (self.view.frame.size.width - draggableHeaderView.frame.size.width  + (dragPoint.x - touchPoint.x));
                self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
            }
        }
        
    }
    else
    {
        CGFloat ty = self.view.transform.ty;
        if((-ty <= self.view.frame.size.height - draggableHeaderView.frame.size.height))
        {
            if(closed)
            {
                self.view.transform = CGAffineTransformMakeTranslation(0, dragPoint.y - touchPoint.y);
            }
            else
            {
                ty = -(self.view.frame.size.height - draggableHeaderView.frame.size.height  - (dragPoint.y - touchPoint.y));
                self.view.transform = CGAffineTransformMakeTranslation(0, ty);
            }
        }
    }
    [UIView commitAnimations];
}

-(void) closeVertical
{
    closed = YES;
    [UIView beginAnimations:@"closing" context:self];
    [UIView setAnimationDelegate:self];
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    [self.view addSubview:draggableHeaderView];
    [draggableCloseHeaderView removeFromSuperview];
    draggableHeaderView.hidden = NO;
    [UIView commitAnimations];
    
}

-(void) closeHorizontal
{
    closed = YES;
    [UIView beginAnimations:@"closing" context:self];
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    [self.view addSubview:draggableHeaderView];
    [draggableCloseHeaderView removeFromSuperview];
    draggableHeaderView.hidden = NO;
    [UIView commitAnimations];
    
}

-(void) openVertical
{
    closed = NO;
    [UIView beginAnimations:@"opening" context:self];
    self.view.transform = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height + draggableHeaderView.frame.size.height  );
    [self.view addSubview:draggableCloseHeaderView];
    [draggableHeaderView removeFromSuperview];
    [UIView commitAnimations];
   
}

-(void) openHorizontal
{
    closed = NO;
    [UIView beginAnimations:@"opening" context:self];
    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width - draggableHeaderView.frame.size.width,0);
    [self.view addSubview:draggableCloseHeaderView];
    [draggableHeaderView removeFromSuperview];
    [UIView commitAnimations];
    
}

-(void) open
{
   if(!closed)
       return;
    
    if(horizontal)
        [self openHorizontal];
    else
        [self openVertical];
}

-(void) close
{
//    if(closed)
//        return;

    if(horizontal)
        [self closeHorizontal];
    else
        [self closeVertical];

}

- (IBAction)dragEnded:(UIControl *)c withEvent:ev {
    
    if(!horizontal)
    {
        if((closed  && (self.view.transform.ty < -self.view.frame.size.height * 0.25f)) || !isDragged)
        {
            if(closed)
            {
                [self openVertical];
                if(useAutoclose)
                    [NSTimer scheduledTimerWithTimeInterval:autocloseInterval target:self selector:@selector(closeVertical) userInfo:nil repeats:NO];
                return;
            }
        }
        if((!closed  && (self.view.transform.ty < self.view.frame.size.height * 0.75f)) || !isDragged)
        {
            [self closeVertical];
            return;
        } 
    }
    else
    {
        if((closed  && (self.view.transform.tx > self.view.frame.size.width * 0.25f)) || !isDragged)
        {
            if(closed)
            {
                [self openHorizontal];
                if(useAutoclose)
                    [NSTimer scheduledTimerWithTimeInterval:autocloseInterval target:self selector:@selector(closeVertical) userInfo:nil repeats:NO];
                return;
            }
        } 
        if((!closed  && (self.view.transform.tx < self.view.frame.size.width * 0.75f)) || !isDragged)
        {
            [self closeHorizontal];
            return;
            
        } 
        
    }
    
    
    self.view.transform = CGAffineTransformMakeTranslation(0,0);
}

@end
