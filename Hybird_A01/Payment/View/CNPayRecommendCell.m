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
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@end

@implementation CNPayRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.normalColor = COLOR_HEX(0xF36F20);
    self.selectColor = COLOR_RGBA(234,115,11,1);
    
    _button.userInteractionEnabled = NO;
    _button.layer.cornerRadius = 4.0;
    _button.layer.borderWidth  = 1;
    _button.layer.borderColor  = self.normalColor.CGColor;
    _button.backgroundColor = [UIColor whiteColor];
    _button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_button setTitleColor:self.normalColor forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

/**
 设置单元格是否处于选中的状态
 
 @param isSelected YES: 已经选中 NO: 没有选中
 */
- (void)settingCellStatusIsSelected:(BOOL)isSelected {
    _button.backgroundColor = isSelected ? self.normalColor : [UIColor whiteColor];
    _button.selected = isSelected;
}


/**
 设置推荐显示金额
 */
- (void)settingAmount:(NSString *)amount {
    [_button setTitle:amount forState:UIControlStateNormal];
}
@end
