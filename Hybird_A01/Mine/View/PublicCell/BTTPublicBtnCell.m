//
//  BTTPublicBtnCell.m
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPublicBtnCell.h"

@interface BTTPublicBtnCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation BTTPublicBtnCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.btn.enabled = NO;
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publicBtnEnableNotification:) name:BTTPublicBtnEnableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publicBtnDisableNotification:) name:BTTPublicBtnDisableNotification object:nil];
}

- (void)publicBtnEnableNotification:(NSNotification *)notifi {
    if ([notifi.object isEqualToString:@"PTTransfer"]) {
        self.btn.enabled = YES;
    } else if ([notifi.object isEqualToString:@"BookMessage"]) {
        self.btn.enabled = YES;
    } else {
        self.btn.enabled = YES;
    }
    
}

- (void)publicBtnDisableNotification:(NSNotification *)notifi {
    if ([notifi.object isEqualToString:@"PTTransfer"]) {
        self.btn.enabled = NO;
    } else if ([notifi.object isEqualToString:@"BookMessage"]) {
        self.btn.enabled = NO;
    }  else {
        self.btn.enabled = NO;
    }
    
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setBtnType:(BTTPublicBtnType)btnType {
    _btnType = btnType;
    if (btnType == BTTPublicBtnTypeConfirm) {
        [self.btn setTitle:@"确定" forState:UIControlStateNormal];
    } else if (btnType == BTTPublicBtnTypeDone) {
        [self.btn setTitle:@"完成" forState:UIControlStateNormal];
    } else if (btnType == BTTPublicBtnTypeNext) {
        [self.btn setTitle:@"下一步" forState:UIControlStateNormal];
    } else if (btnType == BTTPublicBtnTypeSave) {
        [self.btn setTitle:@"保存" forState:UIControlStateNormal];
    }
}

@end
