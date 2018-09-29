//
//  TestCollectionView.m
//  TestVisibleCells
//
//  Created by niuyulong on 2018/9/29.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "TestCollectionView.h"

@implementation TestCollectionView
- (NSArray<UITableViewCell *> *)visibleCells {
    NSLog(@"%s -----",__func__);
    NSArray *array = [super visibleCells];
    NSLog(@"%s =====",__func__);
    return array;
}

- (void)reloadData {
    NSLog(@"%s -----",__func__);
    [super reloadData];
    NSLog(@"%s =====",__func__);
}

- (void)layoutIfNeeded {
    NSLog(@"%s -----",__func__);
    [super layoutIfNeeded];
    NSLog(@"%s =====",__func__);
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    NSLog(@"%s -----",__func__);
    [super layoutSublayersOfLayer:layer];
    NSLog(@"%s =====",__func__);
}

- (void)layoutSubviews {
    NSLog(@"%s -----",__func__);
    [super layoutSubviews];
    NSLog(@"layoutSubviews - visibleCells:%@",@([self visibleCells].count));
    NSLog(@"%s =====",__func__);
}

- (void)setNeedsLayout {
    NSLog(@"%s -----",__func__);
    [super setNeedsLayout];
    NSLog(@"%s =====",__func__);
}

- (void)setNeedsDisplay {
    NSLog(@"%s -----",__func__);
    [super setNeedsDisplay];
    NSLog(@"%s =====",__func__);
}
@end
