//
//  PopoverAction.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTPopoverAction.h"

@interface BTTPopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) NSString *detailTitle;  ///< 副标题
@property (nonatomic, copy, readwrite) void(^handler)(BTTPopoverAction *action); ///< 选择回调

@end

@implementation BTTPopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(BTTPopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(BTTPopoverAction *action))handler {
    BTTPopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle handler:(void (^)(BTTPopoverAction *action))handler {
    BTTPopoverAction *action = [[self alloc] init];
    action.image = nil;
    action.title = title;
    action.detailTitle = detailTitle;
    action.handler = handler;
    
    return action;
}

@end
