//
//  BTTPromoRecordCell.h
//  Hybird_A01
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTPromoRecordModel.h"
@class BTTPromoRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);

@interface BTTPromoRecordCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
-(void)setData:(BTTPromoRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
