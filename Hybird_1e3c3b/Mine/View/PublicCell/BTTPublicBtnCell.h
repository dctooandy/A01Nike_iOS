//
//  BTTPublicBtnCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef enum {
    BTTPublicBtnTypeConfirm,  ///< 确定
    BTTPublicBtnTypeNext,     ///< 下一步
    BTTPublicBtnTypeDone,     ///< 完成
    BTTPublicBtnTypeSave,      ///< 保存
    BTTPublicBtnTypeConfirmSave,  ///< 确认修改
    BTTPublicBtnTypeModify,    ///< 修改
    BTTPublicBtnTypeEnterGame,  ///< 进入游戏大厅
    BTTPublicBtnTypeCustomerService, ///< 联系客服
    BTTPublicBtnTypeSubmit        ///< 提交
}BTTPublicBtnType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPublicBtnCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, assign) BTTPublicBtnType btnType;


@end

NS_ASSUME_NONNULL_END
