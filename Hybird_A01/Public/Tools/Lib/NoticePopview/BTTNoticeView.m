//
//  BTTNoticeView.m
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTNoticeView.h"
#import <Masonry/Masonry.h>

typedef void (^ButtonClickBlock)(void);

@interface BTTNoticeView ()

@property (nonatomic, copy) ButtonClickBlock buttonClickBlock;

@property (nonatomic, strong) UIView *bgView;


@end

@implementation BTTNoticeView

- (void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)title buttonClickedBlock:(void(^)(void))buttonClickedBlock {
    _buttonClickBlock = buttonClickedBlock;
    // 大背景
    UIView *bgView = [[UIView alloc] init];
    bgView.userInteractionEnabled = YES;
    NSLog(@"%@",[UIApplication sharedApplication].windows);
    [[UIApplication sharedApplication].delegate.window addSubview:bgView];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _bgView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick:)];
    [_bgView addGestureRecognizer:tap];
    // 小背景图片
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.userInteractionEnabled = NO;
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.offset(SCREEN_WIDTH / 6 * 4);
        make.height.offset(SCREEN_WIDTH / 6 * 2.5);
    }];
    bgImageView.image = ImageNamed(@"noticeView_bgImg");
    
    UILabel *noticeLabel = [UILabel new];
    [bgImageView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImageView.mas_centerX);
        make.centerY.equalTo(bgImageView.mas_centerY).offset(-(SCREEN_WIDTH / 6 * 3 / 8));
        make.width.equalTo(bgImageView.mas_width);
        make.height.offset(SCREEN_WIDTH / 6 * 3 / 4);
    }];
    noticeLabel.text = message;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
//    noticeLabel.backgroundColor = [UIColor redColor];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:changeBtn];
    changeBtn.userInteractionEnabled = YES;
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImageView.mas_centerX);
        if (SCREEN_WIDTH == 320) {
            make.centerY.equalTo(bgImageView.mas_centerY).offset(SCREEN_WIDTH / 6 * 3 / 8 + 10);
            make.height.offset(35);
        } else if (SCREEN_WIDTH == 414) {
            make.centerY.equalTo(bgImageView.mas_centerY).offset(SCREEN_WIDTH / 6 * 3 / 8 + 20);
            make.height.offset(45);
        } else {
            make.centerY.equalTo(bgImageView.mas_centerY).offset(SCREEN_WIDTH / 6 * 3 / 8 + 15);
            make.height.offset(40);
        }
        make.width.offset(SCREEN_WIDTH / 6 * 2);
    }];
    [changeBtn setTitle:title forState:UIControlStateNormal];
    [changeBtn setBackgroundImage:ImageNamed(@"noticeView_change_btn") forState:UIControlStateNormal];
    
    [changeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancelButton];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"noticeView_close_btn"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(bgImageView.mas_top).mas_offset(-22);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 小白线
    UIView *whiteLine = [UIView new];
    [bgView addSubview:whiteLine];
    whiteLine.backgroundColor = [UIColor whiteColor];
    
    [whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cancelButton.mas_centerX);
        make.top.equalTo(cancelButton.mas_bottom).offset(0);
        make.bottom.equalTo(bgImageView.mas_top).offset(0);
        make.width.equalTo(@1);
    }];
}

- (void)buttonClick:(UIButton *)button {
     [_bgView removeFromSuperview];
    self.buttonClickBlock();
}

- (void)cancelButtonClick:(UIButton *)button {
    [_bgView removeFromSuperview];
}

- (void)bringNoticeViewToFront {
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.bgView];
}




@end
