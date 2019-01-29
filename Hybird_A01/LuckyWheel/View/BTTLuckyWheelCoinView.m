//
//  BTTLuckyWheelCoinView.m
//  Hybird_A01
//
//  Created by Domino on 10/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLuckyWheelCoinView.h"

@interface BTTLuckyWheelCoinView ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;



@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation BTTLuckyWheelCoinView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (IBAction)changeBtnClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
