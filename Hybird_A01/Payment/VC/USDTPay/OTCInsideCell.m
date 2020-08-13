//
//  OTCInsideCell.m
//  Hybird_A01
//
//  Created by Flynn on 2020/7/16.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OTCInsideCell.h"

@interface OTCInsideCell ()
@property(nonatomic, strong) UIImageView * bgImgView;
@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *nameLabel;
@end

@implementation OTCInsideCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-44)/2, (SCREEN_WIDTH-44)/3)];
    if (self) {
        self.bgImgView = [[UIImageView alloc]init];
        self.bgImgView.image = [UIImage imageNamed:@"otc_inside_bg"];
        self.bgImgView.size = CGSizeMake((SCREEN_WIDTH-44)/2, (SCREEN_WIDTH-44)/3);
        self.bgImgView.contentMode = UIViewContentModeScaleToFill;

        [self.contentView addSubview:self.bgImgView];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:self.bgImgView.frame];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:iconImg];
        self.iconImg = iconImg;
        
        self.recommendTagImg = [[UIImageView alloc] init];
        self.recommendTagImg.hidden = true;
        self.recommendTagImg.image = [UIImage imageNamed:@"bfb_youhui"];
        [self.iconImg addSubview:self.recommendTagImg];
        [self.recommendTagImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconImg).offset(-5);
            make.top.equalTo(self.iconImg).offset(5);
        }];

    }
    return self;
}

-(void)cellConfigJson:(OTCInsideModel *)model {
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.otcMarketLogo]];
}

-(void)setBitbaseBgImg {
    self.bgImgView.image = [UIImage imageNamed:@"ic_usdt_bitbase_bg"];
    self.iconImg.size = CGSizeMake(self.bgImgView.frame.size.width, self.bgImgView.frame.size.height*0.9);
    UILabel * lab = [[UILabel alloc] init];
    lab.text = @"支持文信, 支付寶, 銀聯";
    lab.adjustsFontSizeToFitWidth = true;
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImgView);
        make.left.equalTo(self.bgImgView).offset(5);
        make.right.equalTo(self.bgImgView).offset(-5);
        make.height.offset(self.bgImgView.frame.size.height*0.23);
    }];
}

@end
