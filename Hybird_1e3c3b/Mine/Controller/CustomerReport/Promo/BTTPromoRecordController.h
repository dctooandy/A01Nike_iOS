//
//  BTTPromoRecordController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTPromoRecordModel;
@class BTTPromoRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPromoRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)NSMutableDictionary * deleteParams;
@property (nonatomic, strong)NSMutableArray * requestIdArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@property (nonatomic, strong)BTTPromoRecordModel * model;
@property (nonatomic, assign)NSInteger pageNo;
@end

NS_ASSUME_NONNULL_END
