//
//  BTTWithdrawalNotifyCell.h
//  Hybird_1e3c3b
//
//  Created by Key on 2018/12/13.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
@class BTTMeMainModel;
@class BTTBetInfoModel;
@interface BTTWithdrawalNotifyCell : BTTBaseCollectionViewCell
@property (nonatomic, strong) BTTMeMainModel *model;
@property (nonatomic, strong) BTTBetInfoModel *betInfoModel;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIImageView *successImageView;

@end
