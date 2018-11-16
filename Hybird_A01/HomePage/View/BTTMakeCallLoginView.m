//
//  BTTMakeCallLoginView.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMakeCallLoginView.h"

@interface BTTMakeCallLoginView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BTTMakeCallLoginView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([IVNetwork userInfo].phone.length) {
        self.titleLabel.text = [NSString stringWithFormat:@"您绑定的电话为: %@*****%@",[[IVNetwork userInfo].phone substringToIndex:3],[[IVNetwork userInfo].phone substringFromIndex:8]];
    } else {
        self.titleLabel.text = @"您未绑定手机, 请选择其他电话";
    }
    self.bgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgImageView addGestureRecognizer:tap];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)confirmClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)otherClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


@end
