//
//  BTTOtherGameCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTOtherGameCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface BTTOtherGameCell ()

@property (weak, nonatomic) IBOutlet UIButton *shabaBtn;

@property (weak, nonatomic) IBOutlet UIButton *ysbBtn;

//@property (weak, nonatomic) IBOutlet UIButton *jingcaiBtn;

@property (weak, nonatomic) IBOutlet UIButton *asBtn;
@property (weak, nonatomic) IBOutlet UIImageView *asImageView;

@property (weak, nonatomic) IBOutlet UIButton *cpBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shabaBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shabaBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ysbBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ysbBtnWidth;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipBtnHeight;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asBtnWidth;

@property (weak, nonatomic) IBOutlet UIImageView *ysbTryIcon;

//@property (weak, nonatomic) IBOutlet UIImageView *vipTryIcon;

//@property (weak, nonatomic) IBOutlet UIImageView *jingcaiTryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *asTryIcon;

@end

@implementation BTTOtherGameCell


- (void)awakeFromNib {
    [super awakeFromNib];
//    _jingcaiTryIcon.hidden = YES;
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockGameBtnPress) name:@"UnlockGameBtnPress" object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
//    _ybsTryIcon.hidden = YES;
//    _vipTryIcon.hidden = YES;
    _asTryIcon.hidden = YES;
}

- (void)logoutSuccess:(NSNotification *)notifi {
//    _ybsTryIcon.hidden = NO;
//    _vipTryIcon.hidden = NO;
    _asTryIcon.hidden = NO;
}

-(void)unlockGameBtnPress {
    self.shabaBtn.userInteractionEnabled = true;
    self.ysbBtn.userInteractionEnabled = true;
//    self.jingcaiBtn.userInteractionEnabled = true;
    self.asBtn.userInteractionEnabled = true;
    self.cpBtn.userInteractionEnabled = true;
}

-(void)lockGameBtnPress {
    self.shabaBtn.userInteractionEnabled = false;
    self.ysbBtn.userInteractionEnabled = false;
//    self.jingcaiBtn.userInteractionEnabled = false;
    self.asBtn.userInteractionEnabled = false;
    self.cpBtn.userInteractionEnabled = false;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

- (void)setupUI {
    CGFloat width = (SCREEN_WIDTH - 40) / 2 ;
    self.shabaBtnWidth.constant = width;
    self.shabaBtnHeight.constant = self.shabaBtnWidth.constant / 182.5 * 144;
        
    self.ysbBtnWidth.constant = width;
    self.ysbBtnHeight.constant = self.ysbBtnWidth.constant / 182.5 * 144;
    
//    self.vipBtnWidth.constant = (SCREEN_WIDTH - 40) / 335.0 * 74;
//    self.vipBtnHeight.constant = self.vipBtnWidth.constant / 74.0 * 69;
    
    self.asBtnWidth.constant = width;
    self.asBtnHeight.constant = self.asBtnWidth.constant / 167.5 * 83;
    
    if ([IVNetwork savedUserInfo]) {
//        _ybsTryIcon.hidden = YES;
//        _vipTryIcon.hidden = YES;
        _asTryIcon.hidden = YES;
    } else {
//        _ybsTryIcon.hidden = NO;
//        _vipTryIcon.hidden = NO;
        _asTryIcon.hidden = NO;
    }
}
- (void)setAsGameData:(BTTASGameModel *)asGameData
{
//    if (asGameData.gameImg)
//    {
//        [self.asImageView sd_setImageWithURL:[NSURL URLWithString:asGameData.gameImg] placeholderImage:[UIImage imageNamed:@"AS"]];
//    }
}
- (IBAction)shabaBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

- (IBAction)ysbBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

//- (IBAction)jingcaiBtnClick:(UIButton *)sender {
//    if (self.buttonClickBlock) {
//        [self lockGameBtnPress];
//        self.buttonClickBlock(sender);
//    }
//}


- (IBAction)asBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}

- (IBAction)agBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        [self lockGameBtnPress];
        self.buttonClickBlock(sender);
    }
}



@end
