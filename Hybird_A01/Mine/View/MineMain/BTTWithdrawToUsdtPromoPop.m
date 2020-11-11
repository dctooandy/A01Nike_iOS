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
