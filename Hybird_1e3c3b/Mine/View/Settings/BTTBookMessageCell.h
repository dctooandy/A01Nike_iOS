//
//  BTTBookMessageCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel,BTTSMSEmailModifyModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTBookMessageCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTMeMainModel *model;

@property (weak, nonatomic) IBOutlet UISwitch *msmSwith;

@property (weak, nonatomic) IBOutlet UISwitch *emailSwith;

@property (nonatomic, strong) BTTSMSEmailModifyModel *smsModifyModel;

@property (nonatomic, strong) BTTSMSEmailModifyModel *emailModifyModel;

@end

NS_ASSUME_NONNULL_END
