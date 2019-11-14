//
//  BTTOtherGameCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTOtherGameCell.h"

@interface BTTOtherGameCell ()

@property (weak, nonatomic) IBOutlet UIButton *shabaBtn;

@property (weak, nonatomic) IBOutlet UIButton *btiBtn;

@property (weak, nonatomic) IBOutlet UIButton *jingcaiBtn;

@property (weak, nonatomic) IBOutlet UIButton *vipBtn;

@property (weak, nonatomic) IBOutlet UIButton *asBtn;

@property (weak, nonatomic) IBOutlet UIButton *cpBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shabaBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shabaBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btiBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btiBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asBtnWidth;

@property (weak, nonatomic) IBOutlet UIImageView *btiTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *vipTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *jingcaiTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *asTryIcon;

@end

@implementation BTTOtherGameCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    _btiTryIcon.hidden = YES;
    _vipTryIcon.hidden = YES;
    _jingcaiTryIcon.hidden = YES;
    _asTryIcon.hidden = YES;
}

- (void)logoutSuccess:(NSNotification *)notifi {
    _btiTryIcon.hidden = NO;
    _vipTryIcon.hidden = NO;
    _jingcaiTryIcon.hidden = NO;
    _asTryIcon.hidden = NO;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI {
    self.shabaBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 182.5;
    self.shabaBtnHeight.constant = self.shabaBtnWidth.constant / 182.5 * 144;
        
    self.btiBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 152.5;
    self.btiBtnHeight.constant = self.btiBtnWidth.constant / 152.5 * 69;
    
    self.vipBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 74;
    self.vipBtnHeight.constant = self.vipBtnWidth.constant / 74.0 * 69;
    
    self.asBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 167.5;
    self.asBtnHeight.constant = self.asBtnWidth.constant / 167.5 * 83;
    
    if ([IVNetwork userInfo]) {
        _btiTryIcon.hidden = YES;
        _vipTryIcon.hidden = YES;
        _jingcaiTryIcon.hidden = YES;
        _asTryIcon.hidden = YES;
    } else {
        _btiTryIcon.hidden = NO;
        _vipTryIcon.hidden = NO;
        _jingcaiTryIcon.hidden = NO;
        _asTryIcon.hidden = NO;
    }
}

- (IBAction)shabaBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)btiBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)jingcaiBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)vipBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)asBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)agBtnClick:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}



@end
