//
//  BTTThisWeekCell.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTXimaItemModel;

typedef enum {
    BTTXimaThisWeekCellTypeUnSelect,     ///< 未选中
    BTTXimaThisWeekCellTypeSelect,   ///< 选中
    BTTXimaThisWeekCellTypeDisable     ///< 不可选
}BTTXimaThisWeekCellType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTThisWeekCell : BTTBaseCollectionViewCell

@property (nonatomic, assign) BTTXimaThisWeekCellType thisWeekCellType;

@property (nonatomic, strong) BTTXimaItemModel *model;

@property (nonatomic, copy) void (^tapSelecteButton)(BOOL isSelected);

- (void)setItemSelectedWithState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
