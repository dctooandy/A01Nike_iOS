//
//  BTTRefreshGIFHeader.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTRefreshGIFHeader.h"

@implementation BTTRefreshGIFHeader



- (void)prepare {
    [super prepare];
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        NSString *imageName = [NSString stringWithFormat:@"dropdown_anim__000%@",@(i)];
        [idleImages addObject:ImageNamed(imageName)];
    }
    // 设置普通状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *refreshImages = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        NSString *imageNmae = [NSString stringWithFormat:@"dropdown_loading_0%@",@(i)];
        [refreshImages addObject:ImageNamed(imageNmae)];
    }
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:refreshImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshImages forState:MJRefreshStateRefreshing];
}

@end
