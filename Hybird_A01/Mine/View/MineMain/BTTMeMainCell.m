//
//  BTTMeMainCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeMainCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeMainCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@end

@implementation BTTMeMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.nameLabel.font = kFontSystem(14);
    } else {
        self.nameLabel.font = kFontSystem(16);
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
    self.hotLabel.layer.cornerRadius = 2;
    self.iconImg.badgeOffset = CGPointMake(-4, 4);
    self.iconImg.badgeColor = [UIColor colorWithHexString:@"d13847"];
    self.iconImg.redDotOffset = CGPointMake(-4, 4);
    [GJRedDot registNodeWithKey:BTTMineCenterItemsKey
                      parentKey:BTTMineCenterMessage
                    defaultShow:NO];
    [GJRedDot registNodeWithKey:BTTMineCenterItemsKey
                      parentKey:BTTMineCenterVersion
                    defaultShow:YES];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImg.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
    if ([model.name isEqualToString:@"我的优惠"] ||
        [model.name isEqualToString:@"账号安全"] ||
        [model.name isEqualToString:@"设置"] ||
        [model.name isEqualToString:@"站内信"] ||
        [model.name isEqualToString:@"版本更新"]) {
        self.mineArrowsType = BTTMineArrowsTypeNoHidden;
    } else {
        self.mineArrowsType = BTTMineArrowsTypeHidden;
    }
    if ([model.name isEqualToString:@"推荐礼金"]) {
        self.hotLabel.hidden = NO;
        
    } else {
        self.hotLabel.hidden = YES;
    }
    if ([model.name isEqualToString:@"推荐礼金"] ||
        [model.name isEqualToString:@"网络检测"]) {
        self.mineSparaterType = BTTMineSparaterTypeNone;
    } 
    
    if ([model.name isEqualToString:@"站内信"] || [model.name isEqualToString:@"版本更新"]) {
        weakSelf(weakSelf);
        if ([model.name isEqualToString:@"站内信"]) {
            [self setRedDotKey:BTTMineCenterMessage refreshBlock:^(BOOL show) {
                strongSelf(strongSelf);
                NSString *num = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:BTTUnreadMessageNumKey]];
                if (num.integerValue) {
                    strongSelf.iconImg.badgeValue = num;
                }
                strongSelf.iconImg.showRedDot = num;
            } handler:self];
            
        } else {
            [self setRedDotKey:BTTMineCenterVersion refreshBlock:^(BOOL show) {
                strongSelf(strongSelf);
                strongSelf.iconImg.badgeValue = 0;
                strongSelf.iconImg.showRedDot = show;
            } handler:self];
    
        }
    } else {
        self.iconImg.badgeValue = 0;
        self.iconImg.showRedDot = NO;
    }
}

@end
