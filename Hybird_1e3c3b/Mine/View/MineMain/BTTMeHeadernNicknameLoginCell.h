//
//  BTTMeHeadernNicknameLoginCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 29/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^AccountBlanceBlock)(void);
typedef void (^LiCaiBlock)(void);

@interface BTTMeHeadernNicknameLoginCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, copy) AccountBlanceBlock accountBlanceBlock;

@property (nonatomic, copy) LiCaiBlock liCaiBlock;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *liCaiAmount;

@property (nonatomic, copy) NSString *liCaiPlusAmount;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, copy) NSString *changModeImgStr;

@property (weak, nonatomic) IBOutlet UILabel *vipLevelLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;

@property (nonatomic, copy) void (^changModeTap)(NSString * modeStr);

@end

NS_ASSUME_NONNULL_END
