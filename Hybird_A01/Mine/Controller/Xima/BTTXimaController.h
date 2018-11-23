//
//  BTTXimaController.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTXimaTotalModel;

typedef enum {
    BTTXimaCurrentListTypeNoData, ///< 无数据状态
    BTTXimaCurrentListTypeData    ///< 有数据状态
}BTTXimaCurrentListType;

typedef enum {
    BTTXimaHistoryListTypeNoData, ///< 无数据状态
    BTTXimaHistoryListTypeData    ///< 有数据状态
}BTTXimaHistoryListType;

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

@property (nonatomic, assign) BTTXimaStatusType ximaStatusType;

@end

NS_ASSUME_NONNULL_END
