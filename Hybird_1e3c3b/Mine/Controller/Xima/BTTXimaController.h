//
//  BTTXimaController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(IVJResponseObject * _Nullable result);

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

typedef enum {
    BTTXimaDateTypeThisWeek, //本周
    BTTXimaDateTypeLastWeek  //上周
}BTTXimaDateType;

typedef enum {
    BTTXimaThisWeekTypeVaild, ///< 当前
    BTTXimaThisWeekTypeOther  ///< other
}BTTXimaThisWeekType;


@interface BTTXimaController : BTTCollectionViewController

@property (nonatomic, strong) BTTXimaTotalModel *otherModel;

@property (nonatomic, strong) BTTXimaTotalModel *validModel;

@property (nonatomic, strong) BTTXimaTotalModel *histroyModel;

@property (nonatomic, strong) NSArray *historyArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) BTTXimaCurrentListType currentListType;

@property (nonatomic, assign) BTTXimaHistoryListType historyListType;

@property (nonatomic, assign) BTTXimaOtherListType otherListType;

@property (nonatomic, assign) BTTXimaStatusType ximaStatusType;

@property (nonatomic, copy) CompleteBlock completeBlock;

@property (nonatomic, assign) BTTXimaDateType ximaDateType; ///< 洗码页面显示类型

@property (nonatomic, assign) BTTXimaThisWeekType thisWeekDataType; ///< this week 数据类型

@property (nonatomic, copy) NSString *multiBetRate; ///是否有沙巴体育Rate

@end

NS_ASSUME_NONNULL_END
