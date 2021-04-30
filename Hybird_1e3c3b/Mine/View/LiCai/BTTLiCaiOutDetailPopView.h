//
//  BTTLiCaiOutDetailPopView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"
#import "BTTLiCaiTransferRecordModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CloseBtnClickBlock)(UIButton * button);
typedef void (^TransferOutBtnClickBlock)(UIButton * button);

@interface BTTLiCaiOutDetailPopView : UIView
+ (instancetype)viewFromXib;
@property (nonatomic, copy) CloseBtnClickBlock closeBtnClickBlock;
@property (nonatomic, copy) TransferOutBtnClickBlock transferOutBtnClickBlock;
@property (nonatomic, strong)NSMutableArray <BTTLiCaiTransferRecordItemModel *> * modelArr;
@end

NS_ASSUME_NONNULL_END
