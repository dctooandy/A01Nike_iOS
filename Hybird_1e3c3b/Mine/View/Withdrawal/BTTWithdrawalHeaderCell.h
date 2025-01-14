//
//  BTTWithdrawalHeaderCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalHeaderCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) NSString *totalAvailable;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@end

NS_ASSUME_NONNULL_END
