//
//  BTTPayUsdtNoticeView.m
//  Hybird_A01
//
//  Created by Levy on 1/4/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTPayUsdtNoticeView.h"

@interface BTTPayUsdtNoticeView()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation BTTPayUsdtNoticeView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)setIamgeWithType:(NSString *)type{
    if ([type isEqualToString:@"atoken"]) {
        self.imgView.image = [UIImage imageNamed:@"notice_atoken"];
    }else{
        self.imgView.image = [UIImage imageNamed:@"notcie_bitpie"];
    }
}

@end
