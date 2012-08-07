//
//  RIRoundView.m
//  Expenses
//
//  Created by MacBook iAPPLE on 06.08.12.
//  Copyright (c) 2012 AppMake.Ru. All rights reserved.
//

#import "RIRoundView.h"

#define kStepAngle 5*M_PI/180.0

@interface RIRoundView(Private)

- (void)animateDrawing;

@end

@interface RIRoundView()
@property(nonatomic,copy) void (^onCompletion)();
@end

@implementation RIRoundView
@synthesize onCompletion;

- (id)initWithFrame:(CGRect)frame
         firstAngle:(CGFloat)fA
        secondAngle:(CGFloat)sA
        innerRadius:(CGFloat)iR
              color:(UIColor*)color{
    if (self = [super initWithFrame:frame]) {
        firstAngle = fA;
        secondAngle = sA;
        innerRadius = iR;
        drawColor = [[UIColor alloc] initWithCGColor:color.CGColor];
        isDrawing = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)resetValuesForFirstAngle:(CGFloat)fA secondAngle:(CGFloat)sA innerRadius:(CGFloat)iR color:(UIColor*)color{
    firstAngle = fA;
    secondAngle = sA;
    innerRadius = iR;
    [drawColor release];
    drawColor = [[UIColor alloc] initWithCGColor:color.CGColor];
    isDrawing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setNeedsDisplay];
}

- (void)drawFill:(BOOL)animating completion:(void (^)(void))onCompletionBlock{
    self.onCompletion = onCompletionBlock;
    if (animating) {
        isDrawing = YES;
        [self animateDrawing];
    }else {
        firstAngle = 0;
        secondAngle = 2*M_PI;
        [self setNeedsDisplay];
        if (self.onCompletion) {
            self.onCompletion();
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGPoint center = CGPointMake(roundf(rect.size.width/2.0), roundf(rect.size.height/2.0));
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    if (2*M_PI+firstAngle <= secondAngle) {
        CGContextAddArc(context, center.x, center.y, center.y, 0, 2*M_PI,0);
        CGContextAddArc(context, center.x, center.y, innerRadius, 0, 2*M_PI,0);
    }else {
        CGContextAddArc(context, center.x, center.y, center.y, firstAngle, secondAngle,0);
        CGContextAddArc(context, center.x, center.y, innerRadius, firstAngle, secondAngle,0);
    }
    
    CGContextClosePath(context);
    CGContextEOFillPath(context);

    if (isDrawing) {
        [self performSelector:@selector(animateDrawing)
                   withObject:nil
                   afterDelay:0.025f];
    }
}


- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.onCompletion = nil;
    [drawColor release];
    [super dealloc];
}

#pragma mark -
#pragma mark Private

- (void)animateDrawing{
    
    if (2*M_PI+firstAngle <= secondAngle || !isDrawing) {
        isDrawing = NO;
        if (self.onCompletion) {
            self.onCompletion();
        }

        return;
    }
    
    firstAngle -= kStepAngle;
    secondAngle += kStepAngle;
    if (firstAngle >= 2*M_PI) {
        firstAngle = firstAngle - 2*M_PI;
    }
    
    if (secondAngle >= 2*M_PI) {
        secondAngle = secondAngle - 2*M_PI;
    }
    
    
    [self setNeedsDisplay];
  
}

@end
