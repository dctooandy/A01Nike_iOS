//
//  BTTLiCaiBannerCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiBannerCell.h"

@interface BTTLiCaiBannerCell()
@property (nonatomic, strong) UIImageView * bannerView;
@end

@implementation BTTLiCaiBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupBannerView];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setupBannerView {
    self.bannerView = [[UIImageView alloc] init];
    self.bannerView.image = [UIImage imageNamed:@"ic_LiCai_banner"];
    self.bannerView.layer.cornerRadius = 10.0;
    self.bannerView.clipsToBounds = true;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
        make.top.left.equalTo(self).offset(10);
        make.bottom.right.equalTo(self).offset(-10);
    }];
}

-(void)bannerClick {
    if (self.bannerClickBlock) {
        self.bannerClickBlock();
    }
}

@end
