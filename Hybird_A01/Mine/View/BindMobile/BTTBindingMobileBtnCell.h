//
//  BTTBindingMobileBtnCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef enum {
    BTTButtonTypeDone, // 完成
    BTTButtonTypeConfirm, // 确定
    BTTButtonTypeNext,     // 下一步
    BTTButtonTypeChange,    // 修改
    BTTButtonTypeChangeEmail,//修改邮箱
    BTTButtonTypeSearch,    // 查询
    BTTButtonTypeback,       // 返回
    BTTButtonTypeSave        // 保存
}BTTButtonType;


NS_ASSUME_NONNULL_BEGIN

@interface BTTBindingMobileBtnCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, assign) BTTButtonType buttonType;


@end

NS_ASSUME_NONNULL_END
