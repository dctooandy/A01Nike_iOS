//
//  BTTHomePageBannerCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageBannerCell.h"
#import "SDCycleScrollView.h"




@interface BTTHomePageBannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@end

@implementation BTTHomePageBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupBannerView];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setupBannerView {
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth)) delegate:self placeholderImage:ImageNamed(@"default_4")];
    _bannerView.autoScrollTimeInterval = 3.0f;
    [self.contentView addSubview:_bannerView];
}

- (void)setImageUrls:(NSMutableArray *)imageUrls {
    _imageUrls = imageUrls;
    _bannerView.imageURLStringsGroup = [imageUrls copy];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.clickEventBlock) {
        self.clickEventBlock(@(index));
    }
}

@end
