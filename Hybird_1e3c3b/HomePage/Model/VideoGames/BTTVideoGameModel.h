//
//  BTTVideoGameModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoGameModel : BTTBaseModel


@property (nonatomic, copy) NSString *betNumber;

@property (nonatomic, copy) NSString *cnName;

//@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *engName;

@property (nonatomic, copy) NSString *gameImage;

@property (nonatomic, copy) NSString *gameImage2;

@property (nonatomic, copy) NSString *gameImage3;

@property (nonatomic, copy) NSString *gameImage4;

@property (nonatomic, copy) NSString *gameLanguage;

@property (nonatomic, assign) NSInteger gameStyle;

@property (nonatomic, assign) NSInteger gameType;

@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *gameId;

@property (nonatomic, assign) BOOL isCanTryPlay;

@property (nonatomic, assign) BOOL isCoupon;

@property (nonatomic, assign) BOOL isFeatures;

@property (nonatomic, assign) BOOL isFavorite; /// 收藏状态

@property (nonatomic, assign) BOOL isFree;

@property (nonatomic, assign) BOOL isHot;

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic, assign) BOOL isPoolGame;

@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, copy) NSString *likeCount;

@property (nonatomic, copy) NSString *manweiPoolAddress;

@property (nonatomic, copy) NSString *maxAward;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *payline;

@property (nonatomic, assign) NSInteger playerType;

@property (nonatomic, copy) NSString *poolAddress;

@property (nonatomic, copy) NSString *popularity;

@property (nonatomic, copy) NSString *provider;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, copy) NSString *winTimes;

@property (nonatomic, copy) NSString *gameCode;

@property (nonatomic, copy) NSString *platformCode;

@property (nonatomic, copy) NSString *blockChainSingle;

@end

NS_ASSUME_NONNULL_END
