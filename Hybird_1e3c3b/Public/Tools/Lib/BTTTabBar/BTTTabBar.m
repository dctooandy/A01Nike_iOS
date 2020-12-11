//
//  BTTTabBar.m
//  Hybird_1e3c3b
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTTabBar.h"
#import "BTTTabBarButton.h"
#import "BTTTabBarBigButton.h"

@interface BTTTabBar ()
/**
 *  选中的按钮
 */
@property (nonatomic, weak) UIButton *selButton;

/** bigButton */
@property (nonatomic, weak) BTTTabBarButton *bigButton;

/** 需要选中第几个 */
@property (nonatomic, assign) NSUInteger currentSelectedIndex;
@end

@implementation BTTTabBar
/** tabBarTag */
static NSInteger const BXTabBarTag = 12000;

- (void)setItems:(NSArray *)items {
    _items = items;
    // 修复反复赋值之后造成tabbarbutton重复的bug
    if (self.subviews.count) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    }
    // UITabBarItem保存按钮上的图片
    for (int i = 0; i < items.count; i++) {
        UITabBarItem *item = items[i];
        NSLog(@"%@_____%@",item.image,item.selectedImage);
        if (i == 2) {
            BTTTabBarButton *btn = [BTTTabBarButton buttonWithType:UIButtonTypeCustom];
            btn.tag = self.subviews.count + BXTabBarTag;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            btn.item = item;
            [self addSubview:btn];
            self.bigButton = btn;

        } else {
            BTTTabBarButton *btn = [BTTTabBarButton buttonWithType:UIButtonTypeCustom];
            btn.tag = self.subviews.count + BXTabBarTag;
            btn.item = item;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:btn];
            // 子控件的个数
            NSInteger subViewsCount = 1;
            if (self.seletedIndex) {
                subViewsCount = self.seletedIndex + 1;
            }
            if (self.subviews.count == subViewsCount) {
                self.currentSelectedIndex = self.subviews.count - 1;
                // 默认选中第一个
                [self btnClick:btn];
            }
            // 添加观察者
//            [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(btn)];
        }
    }
}

- (void)dealloc {
    for (int i=0; i<self.items.count; i++) {
        if (i != 2) {
//            [self.items[i] removeObserver:self forKeyPath:@"badgeValue"];
        }
    }
}

/**
 *  实现数字的显示
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BTTTabBarButton *btn = (__bridge BTTTabBarButton *)(context);
    UITabBarItem *item = object;
    btn.item = item;
}

- (void)setDelegate:(id<BTTTabBarDelegate>)delegate {
    _delegate = delegate;
    [self btnClick:(BTTTabBarButton *)[self viewWithTag:self.currentSelectedIndex + BXTabBarTag]];
}


- (void)btnClick:(UIButton *)button {
    _selButton.selected = NO;
    
    button.selected = YES;
    
    _selButton = button;
    
    // 通知tabBarVc切换控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
        [_delegate tabBar:self didClickBtn:button.tag - BXTabBarTag];
    }
}

/**
 *  外界设置索引页跟着跳转
 */
- (void)setSeletedIndex:(NSInteger)seletedIndex {
    _seletedIndex = seletedIndex;
    UIButton *button = [self viewWithTag:(BXTabBarTag + seletedIndex)];
    [self btnClick:button];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;

    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width / count;
    
    CGFloat h = 49;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        x = i * w;
//        if (i == 2) {
//            y = -12;
//            h += 17;
//        }  else {
            y = 0;
            h = 49;
//        }
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 这里宽度应该跟突出部分的宽度一样，减少点击反应区域
    CGFloat pointW = 43;
    CGFloat pointH = 61;
    CGFloat pointX = (SCREEN_WIDTH - pointW) / 2;
    CGFloat pointY = -12;
    CGRect rect = CGRectMake(pointX, pointY, pointW, pointH);
    if (CGRectContainsPoint(rect, point)) {
        return self.bigButton;
    }
    return [super hitTest:point withEvent:event];
}


@end
