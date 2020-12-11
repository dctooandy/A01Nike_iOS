//
//  AMSegmentViewController.h
//  HybirdApp
//
//  Created by marks.m on 2018/6/16.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNPayWriteModel;
typedef void (^TransitionFinshBlock)(NSInteger index);

@interface AMSegmentViewController : UIViewController

@property (nonatomic, strong) CNPayWriteModel *writeModel;

@property (nonatomic, copy) NSArray<UIViewController *> *items;

@property (nonatomic, assign, readonly, getter = getCurrentDisplayItemIndex) NSInteger currentDisplayItemIndex;

#pragma 内存复用
- (instancetype)initWithItems:(NSArray<UIViewController *> *)items;
- (void)transitionItemsToIndex:(NSInteger) to complteBlock:(TransitionFinshBlock)complteHandler;

#pragma 不采用内存复用
- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)addOrUpdateDisplayViewController:(UIViewController *)viewController;

@end
