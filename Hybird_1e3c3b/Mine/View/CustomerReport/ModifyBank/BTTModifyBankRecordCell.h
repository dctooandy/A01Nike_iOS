//
//  BTTModifyBankRecordCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTModifyBankRecordModel.h"
@class BTTModifyBankRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyBankRecordCell : BTTBaseCollectionViewCell
-(void)setData:(BTTModifyBankRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
