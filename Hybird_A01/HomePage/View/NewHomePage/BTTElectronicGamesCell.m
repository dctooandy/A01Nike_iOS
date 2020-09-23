//
//  BTTElectronicGamesCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTElectronicGamesCell.h"

@interface BTTElectronicGamesCell ()

@property (weak, nonatomic) IBOutlet UIButton *ttgBtn;

@property (weak, nonatomic) IBOutlet UIButton *fishBtn;

@property (weak, nonatomic) IBOutlet UIButton *mgBtn;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ttgBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ttgBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fishBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fishBtnWidth;

@property (weak, nonatomic) IBOutlet UIImageView *ttgTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *fishTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *mgTryIcon;
@end

@implementation BTTElectronicGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockGameBtnPress) name:@"UnlockGameBtnPress" object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    _ttgTryIcon.hidden = YES;
    _fishTryIcon.hidden = YES;
    _mgTryIcon.hidden = YES;
}

- (void)logoutSuccess:(NSNotification *)notifi {
    _ttgTryIcon.hidden = NO;
    _fishTryIcon.hidden = NO;
    _mgTryIcon.hidden = NO;
}

-(void)unlockGameBtnPress {
    self.ttgBtn.userInteractionEnabled = true;
    self.fishBtn.userInteractionEnabled = true;
    self.mgBtn.userInteractionEnabled = true;
    self.allBtn.userInteractionEnabled = true;
}

-(void)lockGameBtnPress {
    self.ttgBtn.userInteractionEnabled = false;
    self.fishBtn.userInteractionEnabled = false;
    self.mgBtn.userInteractionEnabled = false;
    self.allBtn.userInteractionEnabled = false;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI {
    self.ttgBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 182.5;
    self.ttgBtnHeight.constant = self.ttgBtnWidth.constant / 182.5 * 144;
        
    self.fishBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 152.5;
    self.fishBtnHeight.constant = self.fishBtnWidth.constant / 152.5 * 69;
    
    if ([IVNetwork savedUserInfo]) {
        _ttgTryIcon.hidden = YES;
        _fishTryIcon.hidden = YES;
        _mgTryIcon.hidden = YES;
    } else {
        _ttgTryIcon.hidden = NO;
        _fishTryIcon.hidden = NO;
        _mgTryIcon.hidden = NO;
    }
}

- (IBAction)ttgBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

- (IBAction)fishBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

- (IBAction)mgBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

- (IBAction)allBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}


@end
