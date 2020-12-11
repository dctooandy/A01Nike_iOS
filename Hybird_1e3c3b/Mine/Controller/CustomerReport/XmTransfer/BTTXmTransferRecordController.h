//
//  BTTXmTransferRecordController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTXmTransferRecordModel.h"

@class BTTXmTransferRecordItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTXmTransferRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)BTTXmTransferRecordModel * model;
@end

NS_ASSUME_NONNULL_END
