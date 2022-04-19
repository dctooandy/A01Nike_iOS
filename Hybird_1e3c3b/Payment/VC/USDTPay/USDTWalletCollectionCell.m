//
//  USDTWalletCollectionCell.m
//  Hybird_1e3c3b
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "USDTWalletCollectionCell.h"

@interface USDTWalletCollectionCell()
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (weak, nonatomic) UILabel *youCanTrustLabel;
@property (weak, nonatomic) UIImageView *trustImgView;

@end

@implementation USDTWalletCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-60)/3, 36)];
    if (self) {
        UIButton *itemButton = [self getPortocalBtn];
        itemButton.frame = CGRectMake(0, 0, (SCREEN_WIDTH-60)/3, 36);
//        UIButton *itemButton = [[UIButton alloc]init];
//        itemButton.size = CGSizeMake((SCREEN_WIDTH - 60.0 - 30.0)/3, 36);
//        itemButton.imageView.contentMode = UIViewContentModeScaleToFill;
//        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        itemButton.userInteractionEnabled = NO;
        
//        [itemButton setBackgroundImage:[UIImage imageNamed:@"me_usdt_item_unselect"] forState:UIControlStateNormal];
//        [itemButton setBackgroundImage:[UIImage imageNamed:@"me_usdt_item_select"] forState:UIControlStateSelected];
//        
//        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 6, 0)];
//        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 6, 0)];
//        UILabel *youCanTrustLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60.0 - 30.0)/3 - 20, 0, 20, 15)];
//        youCanTrustLabel.backgroundColor = [UIColor redColor];
//        youCanTrustLabel.font = [UIFont systemFontOfSize:8];;
//        youCanTrustLabel.textColor = [UIColor whiteColor];
//        youCanTrustLabel.textAlignment = NSTextAlignmentCenter;
//        youCanTrustLabel.text = @"推荐";
//        youCanTrustLabel.layer.cornerRadius = 5;
//        youCanTrustLabel.layer.masksToBounds = true;
//
//        [youCanTrustLabel setHidden:YES];
        UIImageView *trustImgView = [[UIImageView alloc] initWithImage:ImageNamed(@"A01_H5APP_充值&取款")];
        trustImgView.frame = CGRectMake((SCREEN_WIDTH-60)/3/2 - 8, -10, 34, 19);
        [trustImgView setHidden:YES];
        [itemButton addSubview:trustImgView];
        [self.contentView addSubview:itemButton];
        _itemButton = itemButton;
//        _youCanTrustLabel = youCanTrustLabel;
        _trustImgView = trustImgView;
        
    }
    return self;
}
#pragma mark - Protocol
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_itemButton setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [_itemButton setImage:[UIImage imageNamed:@"icon_newrecharge_sel"] forState:UIControlStateSelected];
}
- (UIButton *)getPortocalBtn {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_newrecharge_sel"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return btn;
}
- (void)setCellWithName:(NSString *)name imageName:(NSString *)imageName{
    NSString*resultStr=[name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];

    [_itemButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_itemButton setTitle:resultStr forState:UIControlStateNormal];
    if ([name isEqualToString:@"TRC20"])
    {
        [_trustImgView setHidden:NO];
    }else
    {
        [_trustImgView setHidden:YES];
    }
}


- (void)setItemSelected:(BOOL)selected{
    if (selected) {
        [_itemButton setSelected:YES];
    }else{
        [_itemButton setSelected:NO];
    }
}

@end
