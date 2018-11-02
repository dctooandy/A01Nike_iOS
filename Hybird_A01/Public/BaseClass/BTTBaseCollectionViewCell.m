//
//  BTTBaseCollectionViewCell.m
//  A01_Sports
//
//  Created by Domino on 2018/9/27.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface BTTBaseCollectionViewCell()

@property (strong, nonatomic) UIView *seperaterLine;

@property (nonatomic, strong) UIImageView *arrowIcon;

@end

@implementation BTTBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    self.seperaterLine = [UIView new];
    [self.contentView addSubview:self.seperaterLine];
    [self.seperaterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.right.offset(0);
        make.height.equalTo(@0.5);
    }];
    self.seperaterLine.backgroundColor = [UIColor colorWithHexString:@"36364c"];
    
    self.arrowIcon = [UIImageView new];
    self.arrowIcon.image = ImageNamed(@"me_arrow");
    [self.contentView addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.arrowIcon.hidden = YES;
}

- (void)setMineSparaterType:(BTTMineSparaterType)mineSparaterType {
    _mineSparaterType = mineSparaterType;
    switch (_mineSparaterType) {
        case BTTMineSparaterTypeNone:
        {
            self.seperaterLine.hidden = YES;
        }
            break;
        case BTTMineSparaterTypeSingleLine:
        {
            self.seperaterLine.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)setMineArrowsType:(BTTMineArrowsType)mineArrowsType {
    _mineArrowsType = mineArrowsType;
    if (mineArrowsType == BTTMineArrowsTypeNoHidden) {
        self.arrowIcon.hidden = NO;
    } else {
        self.arrowIcon.hidden = YES;
    }
    
}

- (void)setMineArrowsDirectionType:(BTTMineArrowsDirectionType)mineArrowsDirectionType {
    _mineArrowsDirectionType = mineArrowsDirectionType;
    if (mineArrowsDirectionType == BTTMineArrowsDirectionTypeRight) {
        self.arrowIcon.image = ImageNamed(@"me_arrow");
    } else {
        self.arrowIcon.image = ImageNamed(@"blance_arrowup");
    }
}

@end
