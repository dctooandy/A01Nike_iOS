//
//  BTTLiCaiOutDetailPopViewCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTLiCaiTransferRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiOutDetailPopViewCell : UICollectionViewCell
@property (nonatomic, strong)BTTLiCaiTransferRecordItemModel * model;
@property (nonatomic, copy) NSString * endDateStr;
@end

NS_ASSUME_NONNULL_END
