//
//  BTTWithdrawRecordCell.h
//  Hybird_A01
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTWithdrawRecordModel.h"
@class BTTWithdrawRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);

@interface BTTWithdrawRecordCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
-(void)setData:(BTTWithdrawRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
