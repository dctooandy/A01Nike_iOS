//
//  CNPayRecommendCell.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/2.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayRecommendCell.h"
#import "CNPayConstant.h"


@interface CNPayRecommendCell()
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation CNPayRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 设置推荐显示金额
 */
- (void)settingAmount:(NSString *)amount {
    [_button setTitle:amount forState:UIControlStateNormal];
}
@end
