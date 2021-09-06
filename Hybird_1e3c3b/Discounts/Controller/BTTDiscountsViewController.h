//
//  BTTDiscountsViewController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTHomePageHeaderView.h"
#import "BTTPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTDiscountsViewController : BTTCollectionViewController

@property (nonatomic, strong) BTTHomePageHeaderView *nav;

@property (nonatomic, strong) BTTPromotionModel *model;

@property (nonatomic, strong) UIView *inProgressView;

@property (nonatomic, strong) UIScrollView *yearsScrollView;

@property (nonatomic, strong) NSMutableArray *yearsBtnTitle;

@property (nonatomic, assign) NSInteger btnIndex;

-(void)setYearsBtnTitle;

-(void)changeToHistoryPage:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
