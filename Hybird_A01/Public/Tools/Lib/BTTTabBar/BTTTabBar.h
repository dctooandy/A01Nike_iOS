//
//  BTTTabBar.h
//  Hybird_A01
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTTTabBar;
@protocol BTTTabBarDelegate <NSObject>

@optional
- (void)tabBar:(BTTTabBar *)tabBar didClickBtn:(NSInteger)index;

@end

@interface BTTTabBar : UIView
/** 选中的索引 */
@property (nonatomic, assign) NSInteger seletedIndex;

// 模型数组(UITabBarItem)
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<BTTTabBarDelegate> delegate;


@end
