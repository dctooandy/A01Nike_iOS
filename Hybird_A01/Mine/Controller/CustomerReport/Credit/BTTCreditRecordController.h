//
//  BTTCreditRecordController.h
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTCreditRecordModel.h"
#import "BTTCreditXmRecordModel.h"

@class BTTCreditRecordModel;
@class BTTCreditRecordItemModel;
@class BTTCreditXmRecordModel;
@class BTTCreditXmRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTCreditRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)NSMutableDictionary * deleteParams;
@property (nonatomic, strong)NSMutableArray * referenceIdsArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@property (nonatomic, strong)BTTCreditRecordModel * model;

@property (nonatomic, strong)NSMutableArray * xmModelArr;
@property (nonatomic, strong)BTTCreditXmRecordModel * xmModel;
@property (nonatomic, assign)NSInteger pageNo;
@end

NS_ASSUME_NONNULL_END
