//
//  BTTDepositRecordCell.h
//  Hybird_A01
//
//  Created by Jairo on 21/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTDepositRecordModel.h"
@class BTTDepositRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);

@interface BTTDepositRecordCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
-(void)setData:(BTTDepositRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
