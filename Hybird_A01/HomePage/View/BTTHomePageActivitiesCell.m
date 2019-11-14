//
//  BTTHomePageActivitiesCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/12.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageActivitiesCell.h"
#import "SDCycleScrollView.h"
#import "BTTActivityModel.h"
#import <Masonry/Masonry.h>

@interface BTTHomePageActivitiesCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *activitiesView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, assign) CGFloat imageHeight;


@end

@implementation BTTHomePageActivitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    if (SCREEN_WIDTH == 320) {
        _imageHeight = 180;
        self.titleLabel.font = kFontSystem(15);
    } else if (SCREEN_WIDTH == 375) {
        _imageHeight = 200;
    } else if (SCREEN_WIDTH == 414 || KIsiPhoneX) {
        _imageHeight = 220;
    }
    [self.contentView addSubview:self.activitiesView];
    
    self.descLabel = [UILabel new];
    self.descLabel.font = kFontSystem(13);
    self.descLabel.numberOfLines = 0;
    [self.descLabel setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.descLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.activitiesView.mas_bottom).offset(0);
    }];
}

- (SDCycleScrollView *)activitiesView {
    if (!_activitiesView) {
        
        _activitiesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 80, SCREEN_WIDTH - 30, _imageHeight) delegate:self placeholderImage:ImageNamed(@"default_3")];
        _activitiesView.showPageControl = NO;
        _activitiesView.autoScrollTimeInterval = 5;
    }
    return _activitiesView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (index + 1 == _activityModel.imgs.count) {
        if (_reloadBlock) {
            _reloadBlock();
        }
    }
}

- (void)setActivityModel:(BTTActivityModel *)activityModel {
    _activityModel = activityModel;
    if (activityModel) {
        self.activitiesView.imageURLStringsGroup = activityModel.imageUrls;
        self.titleLabel.text = activityModel.title;
        self.activitiesView.titlesGroup = activityModel.imgTitles;
        self.descLabel.text = activityModel.desc;
    }
    
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}



@end
