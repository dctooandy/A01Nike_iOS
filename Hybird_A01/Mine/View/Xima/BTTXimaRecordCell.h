//
//  BTTXimaRecordCell.h
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTXimaRecordItemModel;

typedef enum {
    BTTXimaRecordCellTypeTitle,
    BTTXimaRecordCellTypeFirst,
    BTTXimaRecordCellTypeSecond,
    BTTXimaRecordCellTypeLast
}BTTXimaRecordCellType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaRecordCell : BTTBaseCollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, assign) BTTXimaRecordCellType ximaRecordCellType;

@property (nonatomic, strong) BTTXimaRecordItemModel *model;

@end

NS_ASSUME_NONNULL_END
