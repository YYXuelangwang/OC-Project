//
//  FlodingLayout.m
//  test_1
//
//  Created by hundred wang on 17/4/12.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "FlodingLayout.h"

@interface FlodingLayout(){
    UICollectionViewLayoutAttributes *_layoutAttr;
}

@end

static const CGFloat cellHeight = 320;

/* 0..1 */
static const CGFloat cellVectory = 0.75;

@implementation FlodingLayout


- (void)prepareLayout{
    [super prepareLayout];
    
    //    [self.collectionView.panGestureRecognizer addTarget:self action:@selector(queckMove:)];
}

- (void)queckMove:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint vectory = [pan velocityInView:pan.view];
        if (20 < fabs(vectory.y) && 1000 > fabs(vectory.y)) {
            
            NSInteger row = self.collectionView.contentOffset.y / (cellHeight * cellVectory);
            if (vectory.y < 0 && row < [self.collectionView numberOfItemsInSection:0] - 1) {
                [self.collectionView setContentOffset:CGPointMake(0, (row + 1) * cellHeight * cellVectory) animated:YES];
            }else if (vectory.y > 0 && row > 0){
                [self.collectionView setContentOffset:CGPointMake(0,      row * cellHeight * cellVectory) animated:YES];
            }
            
        }
    }
}

- (CGSize)collectionViewContentSize{
    CGSize size = self.collectionView.frame.size;
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    NSInteger maxCount = size.height / cellHeight;
    
    //计算最后的容量
    CGFloat height = (cellCount - maxCount) * (cellHeight * 0.5) + size.height - (size.height - maxCount * cellHeight) * 0.5;
    height = (cellCount - 1) * cellHeight * cellVectory + size.height;
    
    return CGSizeMake(size.width, height);
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    NSInteger row = proposedContentOffset.y / (cellHeight * cellVectory);
    
    //根据cellHeight*cellVectory*cellVectory来判断显示那一个item
    if (proposedContentOffset.y - row * cellHeight * cellVectory > cellHeight * cellVectory * 0.5) {
        row = row + 1;
    }
    
    return CGPointMake(0, (row) * cellHeight * cellVectory);
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    NSInteger row = proposedContentOffset.y / (cellHeight * cellVectory);
    
    //根据cellHeight*cellVectory*cellVectory来判断显示那一个item
    if (proposedContentOffset.y - row * cellHeight * cellVectory > cellHeight * cellVectory * 0.5) {
        row = row + 1;
    }
    
    //    CGFloat vy = fabs(velocity.y);
    //    if (fabs(vy) > 0 && fabs(vy) < 50) [self.collectionView setContentOffset:CGPointMake(0, (row) * cellHeight * cellVectory) animated:YES];
    
    return CGPointMake(0, (row) * cellHeight * cellVectory);
    
    //       CGSize size = self.collectionView.frame.size;
    //    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //    NSInteger maxCount = size.height / cellHeight;
    //    //倒数的那个
    //    if (maxCount * cellHeight < size.height) {
    //        if (row == cellCount - maxCount - 1) {
    //            row = row - 1;
    //        }
    //    }
    
    
    
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //item的size
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, cellHeight);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = size;
    
    //1,正常情况下
    attributes.center = CGPointMake(size.width * 0.5, size.height * indexPath.row + size.height * 0.5);
    
    //＊计算指定的row,这里是关键，不动的参考点
    NSInteger row = self.collectionView.contentOffset.y / (cellHeight * cellVectory);
    row = row - 1;//这里－1是为了对应index.row
    
    
    if (row >= 0) {
        
        //2,非正常情况下 (静态)，这里是界面在临界点的center
        if (indexPath.row <= row + 1) {
            attributes.center = CGPointMake(size.width * 0.5, size.height * indexPath.row * cellVectory + size.height * 0.5);
            
            //设置zIndex
            if (indexPath.row == row + 1) {
                attributes.zIndex = 1;
            }else{
                attributes.zIndex = 0;
            }
            
        }else{
            attributes.center = CGPointMake(size.width * 0.5, size.height * (row + 1) * cellVectory + size.height * (indexPath.row - row) - size.height * 0.5);
            attributes.zIndex = 2;
        }
        
        
        
        //3,移动中的情况  (动态)，这里计算在滑动中的center
        if (indexPath.row > row + 1) {
            
            //这里改变z轴的index
            //            if (indexPath.row == row + 1) {
            //                attributes.zIndex = 1;
            //            }else{
            //                attributes.zIndex = 2;
            //            }
            
            //计算相对于上一个状态，滑动的距离
            CGFloat offsetY = (row + 1) * cellHeight * cellVectory - self.collectionView.contentOffset.y;
            
            //滑到底部，再往上滑的处理
            //            if (self.collectionView.contentOffset.y >= self.collectionView.contentSize.height) {
            //                offsetY = (row + 1) * cellHeight * 0.5 - self.collectionView.contentSize.height;
            //            }
            
            CGPoint orign = attributes.center;
            
            //计算相对的移动距离
            offsetY = (1 - cellVectory) / cellVectory * offsetY;
            attributes.center = CGPointMake(orign.x, orign.y + offsetY);
        }
        
        //这里是第一次，滑动
    }else{
        
        //2,非正常情况下 (静态)，这里是界面在临界点的center
        attributes.center = CGPointMake(size.width * 0.5, size.height * 0.5 + indexPath.row * size.height);
        
        //3,移动中的情况  (动态)，这里计算在滑动中的center
        if (indexPath.row > row + 1) {
            
            //这里改变z轴的index
            if (indexPath.row == row + 1) {
                attributes.zIndex = 1;
            }else{
                attributes.zIndex = 2;
            }
            
            //第一次移动，相对于初始状态，滑动的距离
            CGFloat offsetY = - self.collectionView.contentOffset.y;
            
            //顶部，再往下移就不做处理
            if (self.collectionView.contentOffset.y < 0) {
                offsetY = 0;
            }
            CGPoint orign = attributes.center;
            
            //计算相对的移动距离
            offsetY = (1 - cellVectory) / cellVectory * offsetY;
            attributes.center = CGPointMake(orign.x, orign.y + offsetY);
        }
    }
    
    return attributes;
}



@end
