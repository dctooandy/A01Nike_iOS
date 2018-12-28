//
//  BTTMineViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindStatusModel.h"

typedef enum : NSUInteger {
    BTTMeSaveMoneyShowTypeAll = 0,
    BTTMeSaveMoneyShowTypeBig = 1,
    BTTMeSaveMoneyShowTypeMore = 2,
    BTTMeSaveMoneyShowTypeNone
} BTTMeSaveMoneyShowType;


NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isShowHidden;

@property (nonatomic, strong) BTTBindStatusModel *statusModel;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, assign) BOOL isFanLi;  ///< 返利

@property (nonatomic, assign) BOOL isOpenAccount;  ///< 开户礼金

@property (nonatomic, copy) NSString *preAmount; ///< 计算余额

@property (nonatomic, assign) BOOL isLoading;  ///< 余额计算中

@property (nonatomic, assign) BTTMeSaveMoneyShowType saveMoneyShowType;

@property (nonatomic, assign) NSInteger saveMoneyCount;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
