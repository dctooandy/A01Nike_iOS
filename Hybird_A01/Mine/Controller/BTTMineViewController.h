//
//  BTTMineViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindStatusModel.h"
#import "BTTShareRedirectModel.h"

typedef enum : NSUInteger {
    BTTMeSaveMoneyShowTypeAll = 0,
    BTTMeSaveMoneyShowTypeBig = 1,
    BTTMeSaveMoneyShowTypeMore = 2,
    BTTMeSaveMoneyShowTypeBigOneMore,  // 只有一行大, 一行more
    BTTMeSaveMoneyShowTypeTwoMore,     // 两行more
    BTTMeSaveMoneyShowTypeNone
} BTTMeSaveMoneyShowType;

typedef enum : NSUInteger {
    BTTSaveMoneyTimesTypeLessTen, ///< 小于十次
    BTTSaveMoneyTimesTypeMoreTen  ///< 多余十次
} BTTSaveMoneyTimesType;


NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isShowHidden;

@property (nonatomic, strong) BTTShareRedirectModel *redirectModel;

@property (nonatomic, strong) BTTBindStatusModel *statusModel;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, assign) BOOL isFanLi;  ///< 返利

@property (nonatomic, assign) BOOL isOpenAccount;  ///< 开户礼金

@property (nonatomic, copy) NSString *preAmount; ///< 计算余额

@property (nonatomic, assign) BOOL isLoading;  ///< 余额计算中

@property (nonatomic, assign) BTTMeSaveMoneyShowType saveMoneyShowType;

@property (nonatomic, assign) NSInteger saveMoneyCount;

@property (nonatomic, assign) BTTSaveMoneyTimesType saveMoneyTimesType;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
