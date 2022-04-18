//
//  BTTWithdrawRecordCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTWithdrawRecordModel.h"
@class BTTWithdrawRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);
typedef void(^CancelRequestBlock)(NSString * requestId);

@interface BTTWithdrawRecordCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
@property (nonatomic, copy) CancelRequestBlock cancelRequestBlock;
@property (nonatomic, copy) void (^detailBtnBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

-(void)setData:(BTTWithdrawRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
