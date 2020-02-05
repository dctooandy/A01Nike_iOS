//
//  BTTRealPersonGameCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTRealPersonGameCell.h"

@interface BTTRealPersonGameCell ()

@property (weak, nonatomic) IBOutlet UIButton *aginBtn;

@property (weak, nonatomic) IBOutlet UIButton *agqjBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (weak, nonatomic) IBOutlet UIImageView *agqjTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *aginTryIcon;

@end

@implementation BTTRealPersonGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    self.aginTryIcon.hidden = YES;
    self.agqjTryIcon.hidden = YES;
}

- (void)logoutSuccess:(NSNotification *)notifi {
    self.aginTryIcon.hidden = NO;
    self.agqjTryIcon.hidden = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI {
    _btnWidth.constant = (SCREEN_WIDTH - 30) / 2 - 5;
    _btnHeight.constant = _btnWidth.constant / 168  * 133;
    if ([IVNetwork savedUserInfo]) {
        self.aginTryIcon.hidden = YES;
        self.agqjTryIcon.hidden = YES;
    } else {
        self.aginTryIcon.hidden = NO;
        self.agqjTryIcon.hidden = NO;
    }
}

- (IBAction)agqjBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)aginBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
