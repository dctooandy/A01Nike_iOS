//
//  BTTCreditRecordCell.h
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTCreditRecordModel.h"
@class BTTCreditRecordItemModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);

@interface BTTCreditRecordCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
-(void)setData:(BTTCreditRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
