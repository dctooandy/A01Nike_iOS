//
//  BTTMeHeadernNicknameLoginCell.h
//  Hybird_A01
//
//  Created by Domino on 29/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^AccountBlanceBlock)(void);

@interface BTTMeHeadernNicknameLoginCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, copy) AccountBlanceBlock accountBlanceBlock;

@property (nonatomic, copy) NSString *totalAmount;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipLevelLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;

@end

NS_ASSUME_NONNULL_END
