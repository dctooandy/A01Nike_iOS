//
//  BTTMeHeaderLoginCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef void (^AccountBlanceBlock)(void);
typedef void (^LiCaiBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeHeaderLoginCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, copy) AccountBlanceBlock accountBlanceBlock;

@property (nonatomic, copy) LiCaiBlock liCaiBlock;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *liCaiAmount;

@property (nonatomic, copy) NSString *liCaiPlusAmount;

@property (nonatomic, copy) NSString *changModeImgStr;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipLevelLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;

@property (nonatomic, copy) void (^changModeTap)(NSString * modeStr);

@end

NS_ASSUME_NONNULL_END
