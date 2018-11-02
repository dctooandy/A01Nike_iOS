//
//  BTTBindingMobileBtnCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileBtnCell.h"

@interface BTTBindingMobileBtnCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Yconstants;
@end

@implementation BTTBindingMobileBtnCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.Yconstants.constant = 0;
    self.warningLabel.hidden = YES;
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyCodeDisableNotification:) name:BTTVerifyCodeDisableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyCodeEnableNotification:) name:BTTVerifyCodeEnableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyCodeSendNotification) name:BTTVerifyCodeSendNotification object:nil];
}

- (void)verifyCodeSendNotification {
    self.Yconstants.constant = 20;
    self.warningLabel.hidden = NO;
}

- (void)verifyCodeDisableNotification:(NSNotification *)notifi {
    if ([notifi.object isEqualToString:@"verifycode"]) {
        self.btn.enabled = NO;
    }
}

- (void)verifyCodeEnableNotification:(NSNotification *)notifi {
    if ([notifi.object isEqualToString:@"verifycode"]) {
        self.btn.enabled = YES;
    }
}

- (void)setButtonType:(BTTButtonType)buttonType {
    switch (buttonType) {
        case BTTButtonTypeDone:
        {
            [self.btn setTitle:@"完成" forState:UIControlStateNormal];
        }
            break;
        case BTTButtonTypeConfirm:
        {
            [self.btn setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
        case BTTButtonTypeNext:
        {
            [self.btn setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        case BTTButtonTypeSearch:
        {
            [self.btn setTitle:@"查询" forState:UIControlStateNormal];
        }
            break;
        case BTTButtonTypeback:
        {
            [self.btn setTitle:@"返回会员中心" forState:UIControlStateNormal];
        }
            break;
        case BTTButtonTypeSave:
        {
            [self.btn setTitle:@"保存" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}


- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
