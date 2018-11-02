//
//  BTTBaseCollectionViewCell.h
//  A01_Sports
//
//  Created by Domino on 2018/9/27.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BTTMineSparaterTypeSingleLine,
    BTTMineSparaterTypeNone
}BTTMineSparaterType;

typedef enum {
    BTTMineArrowsTypeNoHidden, // 不隐藏
    BTTMineArrowsTypeHidden    // 隐藏
}BTTMineArrowsType;

typedef enum {
    BTTMineArrowsDirectionTypeRight, // 箭头向右
    BTTMineArrowsDirectionTypeUp     // 箭头向上
}BTTMineArrowsDirectionType;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BTTButtonClickBlock)(UIButton *button);


@interface BTTBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BTTMineSparaterType mineSparaterType;

@property (nonatomic, assign) BTTMineArrowsType mineArrowsType;

@property (nonatomic, assign) BTTMineArrowsDirectionType mineArrowsDirectionType;

@property (nonatomic, copy) BTTButtonClickBlock buttonClickBlock;

@end

NS_ASSUME_NONNULL_END
