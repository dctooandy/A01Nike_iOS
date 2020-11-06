//
//  BTTWithdrawToUsdtPromoPop.m
//  Hybird_A01
//
//  Created by Jairo on 05/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawToUsdtPromoPop.h"

@interface BTTWithdrawToUsdtPromoPop()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *onePromoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *onePromoSubLab;
@property (weak, nonatomic) IBOutlet UILabel *twoPromoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *twoPromoSubLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomLayout;

@end

@implementation BTTWithdrawToUsdtPromoPop
+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    self.bgImgView.userInteractionEnabled = true;
    [self.bgImgView addGestureRecognizer:bgTap];
    
    self.subTitleLab.adjustsFontSizeToFitWidth = true;
    self.onePromoSubLab.adjustsFontSizeToFitWidth = true;
    self.twoPromoSubLab.adjustsFontSizeToFitWidth = true;
    
    NSString * str = @"150万礼金先到先得";
    NSRange range = [str rangeOfString:@"150万"];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.99 green: 0.90 blue: 0.33 alpha: 1.00]} range:range];
    self.subTitleLab.attributedText = attstr;
    
    str = @"取款USDT首笔赠送5%";
    range = [str rangeOfString:@"首笔赠送5%"];
    attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.82 green: 0.20 blue: 0.13 alpha: 1.00]} range:range];
    self.onePromoTitleLab.attributedText = attstr;
    
    str = @"取款USDT笔笔赠送1.5%";
    range = [str rangeOfString:@"笔笔赠送1.5%"];
    attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.82 green: 0.20 blue: 0.13 alpha: 1.00]} range:range];
    self.twoPromoTitleLab.attributedText = attstr;
    
    if (SCREEN_WIDTH < 375) {
        self.btnBottomLayout.constant = -5;
    }
}

-(void)bgTap {
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)kefuBtnAction:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
