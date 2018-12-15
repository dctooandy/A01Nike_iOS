//
//  BTTXimaController.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

typedef void(^CompleteBlock)(IVRequestResultModel *result, id response);

@class BTTXimaTotalModel;

typedef enum {
    BTTXimaCurrentListTypeNoData, ///< 无数据状态
    BTTXimaCurrentListTypeData,    ///< 有数据状态
    BTTXimaCurrentListTypeLoading ///< 加载中
}BTTXimaCurrentListType;

typedef enum {
    BTTXimaHistoryListTypeNoData, ///< 无数据状态
    BTTXimaHistoryListTypeData,    ///< 有数据状态
    BTTXimaHistoryListTypeLoading ///< 加载中
}BTTXimaHistoryListType;

typedef enum {
    BTTXimaOtherListTypeNoData, ///< 无数据状态
    BTTXimaOtherListTypeData,    ///< 有数据状态
    BTTXimaOtherListTypeLoading ///< 加载中
}BTTXimaOtherListType;

typedef enum {
    BTTXimaStatusTypeNormal,     ///< 洗码正常页面
    BTTXimaStatusTypeSuccess     ///< 洗码成功页面
}BTTXimaStatusType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaController : BTTCollectionViewController

@property (nonatomic, strong) BTTXimaTotalModel *otherModel;

@property (nonatomic, strong) BTTXimaTotalModel *validModel;

@property (nonatomic, strong) BTTXimaTotalModel *histroyModel;

@property (nonatomic, assign) BTTXimaCurrentListType currentListType;

@property (nonatomic, assign) BTTXimaHistoryListType historyListType;

@property (nonatomic, assign) BTTXimaOtherListType otherListType;

@property (nonatomic, assign) BTTXimaStatusType ximaStatusType;

@property (nonatomic, copy) CompleteBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
