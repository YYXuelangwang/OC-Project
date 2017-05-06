//
//  MainCollectionView.m
//  test-2
//
//  Created by hundred wang on 17/4/14.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "MainCollectionView.h"

@implementation MainCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL result = [super gestureRecognizerShouldBegin:gestureRecognizer];
    
    return result;
}





@end
