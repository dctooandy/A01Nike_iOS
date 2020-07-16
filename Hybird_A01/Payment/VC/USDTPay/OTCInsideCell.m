//
//  OTCInsideCell.m
//  Hybird_A01
//
//  Created by Flynn on 2020/7/16.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OTCInsideCell.h"
#import "OTCInsideModel.h"

@interface OTCInsideCell ()
@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *nameLabel;
@end

@implementation OTCInsideCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-44)/2, (SCREEN_WIDTH-44)/3)];
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc]init];
        bgImgView.image = [UIImage imageNamed:@"otc_inside_bg"];
        bgImgView.size = CGSizeMake((SCREEN_WIDTH-44)/2, (SCREEN_WIDTH-44)/3);
        bgImgView.contentMode = UIViewContentModeScaleToFill;

        [self.contentView addSubview:bgImgView];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:bgImgView.frame];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:iconImg];
        self.iconImg = iconImg;
        

        
        
    }
    return self;
}

-(void)cellConfigJson:(NSDictionary *)json{
    OTCInsideModel *model = [OTCInsideModel yy_modelWithJSON:json];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.otcMarketLogo]];
}

@end
