//
//  BTTDepositRecordCell.h
//  Hybird_1e3c3b
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
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t detailBlock;
-(void)setData:(BTTDepositRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
