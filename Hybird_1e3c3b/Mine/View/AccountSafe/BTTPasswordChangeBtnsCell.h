//
//  BTTPasswordChangeBtnsCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPasswordChangeBtnsCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *loginPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *PTPwdBtn;
- (void)setupArrow;
@end

NS_ASSUME_NONNULL_END
