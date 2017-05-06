//
//  TestScrollView.m
//  test-2
//
//  Created by hundred wang on 17/4/15.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "TestScrollView.h"

@implementation TestScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL result = [super gestureRecognizerShouldBegin:gestureRecognizer];
    CGPoint pt = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
    if (sin(M_PI / 18.0) < fabs(pt.y) / fabs(pt.x)) result = NO;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    return view;
}

@end
