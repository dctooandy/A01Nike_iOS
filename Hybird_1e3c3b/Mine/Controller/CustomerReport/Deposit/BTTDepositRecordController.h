//
//  BTTDepositRecordController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTPromoRecordFooterView.h"
@class BTTDepositRecordModel;
@class BTTDepositRecordItemModel;
@class BTTDepositRecordExtraModel;


NS_ASSUME_NONNULL_BEGIN

@interface BTTDepositRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)NSMutableDictionary * deleteParams;
@property (nonatomic, strong)NSMutableArray * requestIdArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@property (nonatomic, strong)BTTDepositRecordModel * model;
@property (nonatomic, assign)NSInteger pageNo;
@end

NS_ASSUME_NONNULL_END
