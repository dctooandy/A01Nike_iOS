//
//  BTTMeHeaderLoginCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef void (^AccountBlanceBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeHeaderLoginCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, copy) AccountBlanceBlock accountBlanceBlock;

@end

NS_ASSUME_NONNULL_END
