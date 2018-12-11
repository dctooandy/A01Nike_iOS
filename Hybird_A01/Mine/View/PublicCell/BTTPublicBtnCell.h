//
//  BTTPublicBtnCell.h
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef enum {
    BTTPublicBtnTypeConfirm,  ///< 确定
    BTTPublicBtnTypeNext,     ///< 下一步
    BTTPublicBtnTypeDone,     ///< 完成
    BTTPublicBtnTypeSave      ///< 保存
}BTTPublicBtnType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPublicBtnCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, assign) BTTPublicBtnType btnType;


@end

NS_ASSUME_NONNULL_END
