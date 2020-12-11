//
//  BTTMakeCallSuccessView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMakeCallSuccessView.h"

@interface BTTMakeCallSuccessView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation BTTMakeCallSuccessView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
