//
//  BTTCardInfoCell.h
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTBankModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface BTTCardInfoCell : BTTBaseCollectionViewCell
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong)BTTBankModel *model;
@property (nonatomic, assign) BOOL isChecking; //正在审核
@end

NS_ASSUME_NONNULL_END
