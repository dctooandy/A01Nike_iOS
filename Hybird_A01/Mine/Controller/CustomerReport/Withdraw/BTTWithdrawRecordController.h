//
//  BTTWithdrawRecordController.h
//  Hybird_A01
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
@class BTTWithdrawRecordModel;
@class BTTWithdrawRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)NSMutableDictionary * deleteParams;
@property (nonatomic, strong)NSMutableArray * requestIdArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@property (nonatomic, strong)BTTWithdrawRecordModel * model;
@property (nonatomic, assign)NSInteger pageNo;
@end

NS_ASSUME_NONNULL_END
