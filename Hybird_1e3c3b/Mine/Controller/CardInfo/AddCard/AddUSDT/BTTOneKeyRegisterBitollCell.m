//
//  BTTOneKeyRegisterBitollCell.m
//  Hybird_1e3c3b
//
//  Created by Levy on 4/3/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTOneKeyRegisterBitollCell.h"
#import "CNPayConstant.h"

@interface BTTOneKeyRegisterBitollCell ()
@property UIButton *onekeyButton;
@end

@implementation BTTOneKeyRegisterBitollCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"212229"];
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        infoView.backgroundColor = [UIColor colorWithHexString:@"212229"];
        [self.contentView addSubview:infoView];
        
        UIButton *onekeyButton = [[UIButton alloc]initWithFrame:infoView.frame];
        [onekeyButton setTitle:@"一键注册币付宝钱包?" forState:UIControlStateNormal];
        onekeyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [onekeyButton setTitleColor:COLOR_RGBA(42, 97, 209, 1) forState:UIControlStateNormal];
        [onekeyButton addTarget:self action:@selector(onekeyBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:onekeyButton];
        _onekeyButton = onekeyButton;
        
    }
    return self;
}

- (void)onekeyBtn_click{
    if (_onekeyRegister) {
        _onekeyRegister();
    }
}

-(void)setIsHidden:(BOOL)hidden{
    _onekeyButton.hidden = hidden;
}

@end
