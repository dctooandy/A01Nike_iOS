//
//  BTTLiCaiOutRecordCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 5/20/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTLiCaiTransferRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiOutRecordCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong)BTTLiCaiTransferRecordItemModel * model;
@end

NS_ASSUME_NONNULL_END
