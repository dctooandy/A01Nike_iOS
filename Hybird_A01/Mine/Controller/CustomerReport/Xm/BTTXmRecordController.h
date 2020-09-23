//
//  BTTXmRecordController.h
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTXmRecordModel.h"

@class BTTXmRecordModel;
@class BTTXmRecordItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTXmRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)NSMutableDictionary * deleteParams;
@property (nonatomic, strong)NSMutableArray * requestIdArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@property (nonatomic, strong)BTTXmRecordModel * model;
@property (nonatomic, assign)NSInteger pageNo;
@end

NS_ASSUME_NONNULL_END
