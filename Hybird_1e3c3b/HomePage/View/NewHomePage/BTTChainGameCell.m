//
//  BTTChainGameCell.m
//  Hybird_1e3c3b
//
//  Created by Andy on 2022/4/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTChainGameCell.h"
@interface BTTChainGameCell()
@property (weak, nonatomic) IBOutlet UIButton *chainButton;
@property (weak, nonatomic) IBOutlet UIImageView *chainTryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *chainImageView;

@end
@implementation BTTChainGameCell

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
- (void)setAsGameData:(BTTASGameModel *)asGameData
{
    if (asGameData.gameImg)
    {
        [self.chainImageView sd_setImageWithURL:[NSURL URLWithString:asGameData.gameImg] placeholderImage:[UIImage imageNamed:@"AS"]];
    }
}
- (void)loginSuccess:(NSNotification *)notifi {
    self.chainTryIcon.hidden = YES;
}

- (void)logoutSuccess:(NSNotification *)notifi {
    self.chainTryIcon.hidden = NO;
}
-(void)unlockGameBtnPress {
    self.chainButton.userInteractionEnabled = true;
}
-(void)lockGameBtnPress {
    self.chainButton.userInteractionEnabled = false;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI {
    if ([IVNetwork savedUserInfo]) {
        self.chainTryIcon.hidden = YES;
    } else {
        self.chainTryIcon.hidden = NO;
    }
}
- (IBAction)chainGameAction:(id)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

@end
