//
//  BTTLiCaiInRecordCell.h
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/5/20.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTLiCaiTransferRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiInRecordCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong)BTTLiCaiTransferRecordItemModel * model;
@end

NS_ASSUME_NONNULL_END
