//
//  BTTXmRecordCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTXmRecordModel.h"
@class BTTXmRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckBtnClickBlock)(NSString * requestId, BOOL selected);
@interface BTTXmRecordCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, copy) CheckBtnClickBlock checkBtnClickBlock;
-(void)setData:(BTTXmRecordItemModel *)model;
@end

NS_ASSUME_NONNULL_END
