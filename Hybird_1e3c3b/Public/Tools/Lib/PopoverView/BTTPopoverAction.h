//
//  BTTPopoverAction.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BTTPopoverViewStyle) {
    BTTPopoverViewStyleDefault = 0, // 默认风格, 白色
    BTTPopoverViewStyleDark, // 黑色风格
};

@interface BTTPopoverAction : NSObject

@property (nonatomic, strong, readonly) UIImage *image; ///< 图标 (建议使用 60pix*60pix 的图片)
@property (nonatomic, copy, readonly) NSString *title; ///< 标题
@property (nonatomic, copy, readonly) NSString *detailTitle;  ///< 副标题
@property (nonatomic, copy, readonly) void(^handler)(BTTPopoverAction *action); ///< 选择回调, 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(BTTPopoverAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(BTTPopoverAction *action))handler;

+ (instancetype)actionWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle handler:(void (^)(BTTPopoverAction *action))handler;

@end
